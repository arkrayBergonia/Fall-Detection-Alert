//
//  DataViewController.swift
//  Fall Detection Alert
//
//  Created by Francis Jemuel Bergonia on 24/10/2019.
//  Copyright © 2019 Arkray Marketing, Inc. All rights reserved.
//

import UIKit

class DataViewController: UIViewController {

    @IBOutlet weak var dataLabel: UILabel!
    var dataObject: String = ""


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.dataLabel!.text = dataObject
    }


}

