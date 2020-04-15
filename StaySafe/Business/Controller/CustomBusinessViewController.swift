//
//  CustomBusinessViewController.swift
//  StaySafe
//
//  Created by Mazen on 14/04/20.
//  Copyright © 2020 iProgram. All rights reserved.
//

import UIKit

class CustomBusinessViewController: UITableViewController {

    @IBOutlet private weak var submitButton: UIBarButtonItem!
    @IBOutlet private weak var nameTextField: CATextField!
    @IBOutlet private weak var addressTextField: CATextField!
    
    enum SegueID {
        static let showQRBadge = "showPrintCustomMerchantQR"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func submitButtonTapped(_ sender: Any) {
        guard isScreenValid() else { return }
        
        Alert.showLoading (title: "") { [weak self] in
            Alert.hideLoading()
            self?.closeButtonTapped()
        }
    }
    
    @IBAction func closeButtonTapped() {
        navigationController?.dismiss(animated: true)
    }

    @IBAction func viewTapped(_ sender: Any) {
        tableView.endEditing(true)
    }

    private func isScreenValid() -> Bool {
        return nameTextField.isValid(true) &&
            addressTextField.isValid(true)
    }
    
    private func reloadScreen() {
        submitButton.isEnabled = isScreenValid()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let segueID = segue.identifier else { return }
        
        switch segueID {
        case SegueID.showQRBadge:
            let vc = segue.destination as! BusinessQRViewController
            
            guard let name = nameTextField.text,
                let address = addressTextField.text
                else { return }
            
            vc.placemark = Placemark(businessName: name, businessAddress: address)
            
        default:
            break
        }
    }

}

extension CustomBusinessViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            addressTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        reloadScreen()
    }
    
    
}