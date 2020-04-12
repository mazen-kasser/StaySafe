//
//  MerchantViewController.swift
//  StaySafe
//
//  Created by Mazen on 7/04/20.
//  Copyright © 2020 iProgram. All rights reserved.
//

import UIKit

class MerchantQRViewController: UIViewController, ShareableScreen {
    
    @IBOutlet weak var qrImageView: UIImageView!
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var businessAddressLabel: UILabel!
    
    var placemark: Placemark!
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        applyShareButton(for: .right, selector: #selector(shareReceipt))
        
        qrImageView.image = QRGenerator.generateQRCode(from: placemark.description)
        businessNameLabel.text = placemark.businessName
        businessAddressLabel.text = placemark.businessAddress
    }
    
    @objc func shareReceipt() {
        displayShareOptions(popoverDelegate: self)
    }
    
}

extension MerchantQRViewController: UIPopoverPresentationControllerDelegate {
    
    func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
        popoverPresentationController.barButtonItem = navigationItem.rightBarButtonItem
    }
}
