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
    
    func startDetection()  {
        if manager.isDeviceMotionAvailable{
            manager.startAccelerometerUpdates(to: OperationQueue.current!) { (data, error) in
                if let myData = data {
                    
                    if  (abs(myData.acceleration.x) + abs(myData.acceleration.y) + abs(myData.acceleration.z)) >= 6.25 {
                        
                        print ((abs(myData.acceleration.x) + abs(myData.acceleration.y) + abs(myData.acceleration.z)))
                        let lvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "fallDetectedVC")
                        self.present(lvc, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    

}
