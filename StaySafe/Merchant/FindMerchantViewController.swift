//
//  MerchantViewController.swift
//  StaySafe
//
//  Created by Mazen on 7/04/20.
//  Copyright © 2020 iProgram. All rights reserved.
//

import UIKit

class FindMerchantViewController: UIViewController {
    
    enum SegueID {
        static let showQRBadge = "showPrintMerchantQR"
    }
    
    @IBOutlet weak var addressTextField: UITextField!
    
    @IBAction func generateQRCode(_ sender: Any) {
        performSegue(withIdentifier: SegueID.showQRBadge, sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let segueID = segue.identifier else { return }
        
        switch segueID {
        case SegueID.showQRBadge:
            let vc = segue.destination as! MerchantQRViewController
            vc.businessAddress = addressTextField.text ?? ""
            
        default:
            break
        }
    }
    
}
