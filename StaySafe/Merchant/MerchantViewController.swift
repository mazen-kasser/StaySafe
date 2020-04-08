//
//  MerchantViewController.swift
//  StaySafe
//
//  Created by Mazen on 7/04/20.
//  Copyright © 2020 iProgram. All rights reserved.
//

import UIKit

class MerchantViewController: UIViewController {
    
    @IBOutlet weak var qrImageView: UIImageView!
    @IBOutlet weak var addressTextField: UITextField!
    
    @IBAction func generateQRCode(_ sender: Any) {
        qrImageView.image = QRGenerator.generateQRCode(from: addressTextField.text ?? "")
    }
    
    @IBAction func dismiss(_ sender: Any) {
        navigationController?.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}
