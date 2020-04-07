//
//  CustomerViewController.swift
//  StaySafe
//
//  Created by Mazen on 7/04/20.
//  Copyright © 2020 iProgram. All rights reserved.
//

import UIKit

class CustomerViewController: UIViewController {
 
    @IBOutlet weak var deviceIdentifierLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.deviceIdentifierLabel.text = UserDefaults.standard.string(forKey: "deviceToken")
    }
}
