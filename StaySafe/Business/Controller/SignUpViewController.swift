//
//  Copyright © 2020 iProgram. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UITableViewController {

    @IBOutlet private weak var submitButton: UIButton!
    @IBOutlet private weak var emailTextField: CATextField!
    @IBOutlet private weak var passwordTextField: CATextField!
    @IBOutlet private weak var confirmPasswordTextField: CATextField!
    
    enum SegueID {
        static let showFindMyBusiness = "showFindBusinessViewController"
    }

    @IBAction func viewTapped(_ sender: Any) {
        tableView.endEditing(true)
    }
    
    @IBAction func submitDidTouch(_ sender: Any) {
        
        guard let email = emailTextField.text,
            let password = passwordTextField.text
            else { return }
        
        self.submitButton.isEnabled = false
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if error == nil {
                self.startSignedInFlow()
            } else if let error = error {
                self.presentAlert(title: "Error", message: error.localizedDescription)
            }
                
            self.submitButton.isEnabled = true
        }
    }
    
    private func startSignedInFlow() {
        performSegue(withIdentifier: SegueID.showFindMyBusiness, sender: nil)
    }
    
    private func isScreenValid() -> Bool {
        return emailTextField.isValid(true) &&
            passwordTextField.isValid(true) &&
            confirmPasswordTextField.isValid(true)
    }
    
    private func reloadScreen() {
        if isScreenValid() &&
            passwordTextField.text != confirmPasswordTextField.text {
            presentAlert(title: "Error", message: "Passwords not matching")
            return
        }
    
        submitButton.isEnabled = isScreenValid()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let segueID = segue.identifier else { return }
        
        switch segueID {
        case SegueID.showFindMyBusiness:
            
            guard let email = emailTextField.text,
                let password = passwordTextField.text
                else { return }
            
            UserDefaults.standard.emailAddress = email
            UserDefaults.standard.password = password
            
        default:
            break
        }
    }

}

extension SignUpViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            confirmPasswordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        reloadScreen()
    }
    
    
}
