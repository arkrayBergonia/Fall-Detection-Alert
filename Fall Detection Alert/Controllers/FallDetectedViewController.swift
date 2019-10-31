//
//  FallDetectedViewController.swift
//  Fall Detection Alert
//
//  Created by Francis Jemuel Bergonia on 10/30/19.
//  Copyright © 2019 Arkray Marketing, Inc. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox

class FallDetectedViewController: UIViewController {
    
    @IBOutlet var imageView: UIView!
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var mainButton: RoundedButton!
    
    var counter = 10
    var counterTimer : Timer!
    var player: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //start the warning timer before confirming a fall
        self.counterTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.runTimedCode), userInfo: nil, repeats: true)
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        counterTimer.invalidate()
        self.player?.stop()
    }
    
    @objc func runTimedCode() {
        //statusLabel.text = "STATUS: Fall Dectected \n calling contacts in \(counter)s"
        counter = counter - 1
        self.playSound()
        //self.counterLabel.text = "\(counter) seconds"
        if (counter == 0) {
            counterTimer.invalidate()
            self.counter = 10
            self.player?.volume = 0.0
            self.player?.stop()
//            let lvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "fallDetectedVC")
//            self.present(lvc, animated: true, completion: nil)
        }
    }
    
    fileprivate func playSound() {
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
            self.player?.volume = 1.0
            self.player?.play()
            
        } catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
    }

}
