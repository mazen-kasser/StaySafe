//
//  ContactUsViewController.swift
//  StaySafe
//
//  Created by Mazen on 13/04/20.
//  Copyright © 2020 iProgram. All rights reserved.
//

import UIKit

class ContactUsViewController: UITableViewController {

    @IBOutlet private weak var contactNameTextField: UITextField!
    @IBOutlet private weak var mobileNumberTextField: UITextField!

    @IBAction func submitButtonTapped(_ sender: Any) {
        guard isScreenValid() else { return }
        
        // TODO: API call
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
        return true
// TODO: add validation rules
//        return contactNameTextField.isValid(true) &&
//            mobileNumberTextField.isValid(true)
    }
    
}
