//
//  DetectionViewController.swift
//  Fall Detection Alert
//
//  Created by Francis Jemuel Bergonia on 28/10/2019.
//  Copyright © 2019 Arkray Marketing, Inc. All rights reserved.
//


import UIKit
import CoreMotion
import CoreLocation
import AVFoundation
import AudioToolbox

class DetectionViewController: UIViewController ,CLLocationManagerDelegate{
    
    //View Labels
    @IBOutlet weak var fallImageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var switchLabel: UILabel!
    @IBOutlet weak var switchBtnOutlet: UISwitch!
    
    //Sensor Values
    @IBOutlet weak var accX: UILabel!
    @IBOutlet weak var accY: UILabel!
    @IBOutlet weak var accZ: UILabel!
    @IBOutlet weak var accSum: UILabel!
    @IBOutlet weak var gX: UILabel!
    @IBOutlet weak var gY: UILabel!
    @IBOutlet weak var gZ: UILabel!
    
    @IBOutlet weak var cordsX: UILabel!
    @IBOutlet weak var cordsY: UILabel!
    
    var accX_measure : Double = 0
    var accY_measure : Double = 0
    var accZ_measure : Double = 0
    var accSum_measure : Double = 0
    var gX_measure : Double = 0
    var gY_measure : Double = 0
    var gZ_measure : Double = 0
    
    @IBOutlet weak var rotX: UILabel!
    @IBOutlet weak var rotY: UILabel!
    @IBOutlet weak var rotZ: UILabel!

    var rotX_measure : Double = 0
    var rotY_measure : Double = 0
    var rotZ_measure : Double = 0
    
    var counter = 10
    var counterTimer : Timer!
    var iAmOkayIndicator = true
    var introPresented = false
    
    var player: AVAudioPlayer?
    
    let manager = CMMotionManager()
    let locationManager = CLLocationManager()
    
    
    @IBOutlet weak var btnDetection: UIButton!
    @IBOutlet weak var sensorValues: UIStackView!
    @IBOutlet weak var counterView: UIView!
    @IBOutlet weak var counterLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.btnDetection.layer.cornerRadius = 10
        self.btnDetection.clipsToBounds = true
        
        // Do any additional setup after loading the view.
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !introPresented {
            //let vc = IntroViewController()
            let lvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "IntroVC")
            self.present(lvc, animated: true, completion: nil)
            self.introPresented = true
        }
        
    }
    
    
    @IBAction func switchDetection(_ sender: Any) {
        if btnDetection.titleLabel?.text == "Start Detection"{
            btnDetection.setTitle("Stop Detection", for: .normal)
            startDetection()
            self.switchBtnOutlet.setOn(true, animated: true)
        }else{
            if !iAmOkayIndicator {
               self.counterTimer.invalidate()
            }
            self.counterLabel.isHidden = true
            self.player?.pause()
            self.player?.stop()
            btnDetection.setTitle("Start Detection", for: .normal)
            stopDetection()
            self.switchBtnOutlet.setOn(false, animated: true)
        }
    }
    
    
    @IBAction func detectionSwitchTapped(_ sender: UISwitch) {
        
        if sender.isOn {
            switchLabel.text = "Fall Detection: ON"
            statusLabel.text = "STATUS: Monitoring . . ."
            btnDetection.setTitle("Stop Detection", for: .normal)
            startDetection()
            
        } else {
            switchLabel.text = "Fall Detection: OFF"
            statusLabel.text = "Turn switch ON to monitor"
            btnDetection.setTitle("Start Detection", for: .normal)
            stopDetection()
        }
        
    }
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "zapsplat_alarm_siren01", withExtension: "mp3") else {
            print("url not found")
            return
        }
        
        do {
            /// this codes for making this app ready to takeover the device audio
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            /// change fileTypeHint according to the type of your audio file (you can omit this)
            
            /// for iOS 11 onward, use :
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            /// else :
            /// player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3)
            
            // no need for prepareToPlay because prepareToPlay is happen automatically when calling play()
            player!.play()
        } catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
    }
    
    
    func startDetection()  {
        self.resetValues()

        if manager.isDeviceMotionAvailable{
            manager.deviceMotionUpdateInterval = 0.1
            manager.startDeviceMotionUpdates(to: OperationQueue.current!, withHandler:{
                (deviceData: CMDeviceMotion? , NSError)-> Void in
                self.outputGravityData(gravity: deviceData!.gravity)
                self.outputAccData(acceleration: deviceData!.userAcceleration)
                self.outputRotData(rotation: deviceData!.rotationRate)
                if (NSError != nil){
                    print("\(String(describing: NSError))")
                }
            } )
            
            manager.startAccelerometerUpdates(to: OperationQueue.current!) { (data, error) in
                
                if let myData = data
                {
                    
                    if  (abs(myData.acceleration.x) + abs(myData.acceleration.y) + abs(myData.acceleration.z)) >= 6.25 //6.25
                    {
                        self.iAmOkayIndicator = false
                        self.counterView.isHidden = false
                        self.stopDetection()
                        print ((abs(myData.acceleration.x) + abs(myData.acceleration.y) + abs(myData.acceleration.z)))
                        //start the warning timer before confirming a fall
                        self.counterTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.runTimedCode), userInfo: nil, repeats: true)
                    }
                }
            }
        }
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    @objc func runTimedCode() {
        statusLabel.text = "STATUS: Fall Dectected \n calling contacts in \(counter)s"
        counter = counter - 1
        self.playSound()
        self.counterLabel.text = "\(counter) seconds"
        if (counter == 0)
        {
            counterTimer.invalidate()
           
            if !iAmOkayIndicator {
                self.introPresented = true
                self.counter = 10
                self.iAmOkayIndicator = true
                let lvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "fallDetectedVC")
                self.present(lvc, animated: true, completion: nil)
            }
        }
    }
        
        
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        
        cordsX?.text = "\(locValue.latitude)"
        cordsY?.text = "\(locValue.longitude)"

    }
    
    func stopDetection(){
        manager.stopDeviceMotionUpdates()
        self.resetValues()
    }
    
    func resetValues(){
        accX_measure = 0
        accY_measure = 0
        accZ_measure = 0
        accX?.text = "X: 0  g-force"
        accY?.text = "Y: 0  g-force"
        accZ?.text = "Z: 0  g-force"
        accSum.text = "Sum: 0 g-force"
        rotX_measure = 0
        rotY_measure = 0
        rotZ_measure = 0
        rotX?.text = "rotX: 0 rad/s"
        rotY?.text = "rotY: 0 rad/s"
        rotZ?.text = "rotZ: 0 rad/s"
        gX?.text = "gx: 0  g-force"
        gY?.text = "gy: 0  g-force"
        gZ?.text = "gz: 0  g-force"
    }
    func outputRotData(rotation: CMRotationRate) {
        rotX?.text = "rotX:\(round(rotation.x * 1000)/1000) rad/s"
        rotY?.text = "rotY:\(round(rotation.y * 1000)/1000) rad/s"
        rotZ?.text = "rotZ:\(round(rotation.z * 1000)/1000) rad/s"
    }
    func outputAccData(acceleration: CMAcceleration) {
        accX_measure = acceleration.x
        accY_measure = acceleration.y
        accZ_measure = acceleration.z
        
        accSum_measure = (round(sqrt(pow(accX_measure, 2) + pow(accY_measure, 2) + pow(accZ_measure, 2))))
        accX?.text = "X:\(NSString .localizedStringWithFormat("%.4f", accX_measure))  g-force"
        accY?.text = "Y:\(NSString .localizedStringWithFormat("%.4f", accY_measure))  g-force"
        accZ?.text = "Z:\(NSString .localizedStringWithFormat("%.4f", accZ_measure))  g-force"
        accSum?.text = "Sum:\(accSum_measure) g-force"
    }
    //output gravity
    func outputGravityData(gravity: CMAcceleration) {
        gX_measure = gravity.x
        gY_measure = gravity.y
        gZ_measure = gravity.z
        gX?.text = "gx:\(NSString .localizedStringWithFormat("%.4f", gX_measure)) g-force"
        gY?.text = "gy:\(NSString .localizedStringWithFormat("%.4f", gY_measure)) g-force"
        gZ?.text = "gz:\(NSString .localizedStringWithFormat("%.4f", gZ_measure)) g-force"
    }
    
}
