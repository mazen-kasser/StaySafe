//
//  MerchantViewController.swift
//  StaySafe
//
//  Created by Mazen on 7/04/20.
//  Copyright © 2020 iProgram. All rights reserved.
//

import UIKit

class MerchantQRViewController: UIViewController {
    
    @IBOutlet weak var qrImageView: UIImageView!
    @IBOutlet weak var businessNameLabel: UILabel!
    
    var businessAddress: String!
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        qrImageView.image = QRGenerator.generateQRCode(from: businessAddress)
        businessNameLabel.text = businessAddress
    }
    
    @IBAction func shareQRBadge(_ sender: Any) {
        
    }
}
