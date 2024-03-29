//
//  FallSensingViewController.swift
//  Fall Detection Alert
//
//  Created by Francis Jemuel Bergonia on 10/30/19.
//  Copyright © 2019 Arkray Marketing, Inc. All rights reserved.
//

import UIKit
import CoreMotion

class FallSensingViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var mainButton: RoundedButton!
    
    var introPresented = false
    let manager = CMMotionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func mainBtnTapped(_ sender: Any) {
        if mainButton.titleLabel?.text == "Start Detection"{
            mainButton.setTitle("Stop Detection", for: .normal)
            mainButton.backgroundColor = UIColor.orange
            self.statusLabel.text = "STATUS: Monitoring"
            startDetection()
        } else {
            mainButton.setTitle("Start Detection", for: .normal)
            mainButton.backgroundColor = UIColor.red
            self.statusLabel.text = "STATUS: OFF "
            stopDetection()
        }
    }
    
    private func startDetection()  {
        if manager.isDeviceMotionAvailable{
            manager.startAccelerometerUpdates(to: OperationQueue.current!) { (data, error) in
                if let myData = data {
                    
                    if  (abs(myData.acceleration.x) + abs(myData.acceleration.y) + abs(myData.acceleration.z)) >= 4.25 {
                        
                        print ((abs(myData.acceleration.x) + abs(myData.acceleration.y) + abs(myData.acceleration.z)))
                        let lvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "fallDetectedVC")
                        self.present(lvc, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    

    private func stopDetection(){
        manager.stopDeviceMotionUpdates()
    }
}
