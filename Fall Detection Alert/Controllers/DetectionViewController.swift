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

class DetectionViewController: UIViewController ,CLLocationManagerDelegate{
    
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
    
    let manager = CMMotionManager()
    let locationManager = CLLocationManager()
    
    
    @IBOutlet weak var btnDetection: UIButton!
    // Shadow and Radius for Circle Button
    
    @IBAction func switchDetection(_ sender: Any) {
        if btnDetection.titleLabel?.text == "Start Detection"{
            btnDetection.setTitle("Stop Detection", for: .normal)
            startDetection()
        }else{
            btnDetection.setTitle("Start Detection", for: .normal)
            stopDetection()
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

        }
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnDetection.layer.shadowColor = UIColor.black.cgColor
        btnDetection.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        btnDetection.layer.masksToBounds = false
        btnDetection.layer.shadowRadius = 1.0
        btnDetection.layer.shadowOpacity = 0.5
        btnDetection.layer.cornerRadius = btnDetection.frame.width / 2
        // Do any additional setup after loading the view.
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
    }
    
}
