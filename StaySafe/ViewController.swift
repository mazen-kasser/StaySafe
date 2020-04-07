//
//  ViewController.swift
//  StaySafe
//
//  Created by Mazen on 6/04/20.
//  Copyright © 2020 iProgram. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var deviceTokenLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.deviceTokenLabel.text = UserDefaults.standard.string(forKey: "deviceToken")
    }


}

