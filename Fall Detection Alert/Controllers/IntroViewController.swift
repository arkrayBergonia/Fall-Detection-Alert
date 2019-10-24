//
//  IntroViewController.swift
//  Fall Detection Alert
//
//  Created by Francis Jemuel Bergonia on 24/10/2019.
//  Copyright © 2019 Arkray Marketing, Inc. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textViewInfo: UITextView!
    @IBOutlet weak var mainButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.mainButton.layer.cornerRadius = 10
        self.mainButton.clipsToBounds = true
    }
    
    @IBAction func btnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
