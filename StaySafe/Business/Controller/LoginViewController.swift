//
//  Copyright © 2020 iProgram. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UITableViewController {

    @IBOutlet private weak var submitButton: UIButton!
    @IBOutlet private weak var emailTextField: CATextField!
    @IBOutlet private weak var passwordTextField: CATextField!
    
    enum SegueID {
        static let showQRBadge = "showBusinessQRViewController"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rootRef = Database.database().reference()
        let childRef = Database.database().reference(withPath: "checkin-items")
        let itemsRef = rootRef.child("checkin-items")
        let milkRef = itemsRef.child("milk")
        
        print(rootRef.key)
        print(childRef.key)
        print(itemsRef.key)
        print(milkRef.key)
        
        let listener = Auth.auth().addStateDidChangeListener {
          auth, user in
            if user != nil {
              self.performSegue(withIdentifier: SegueID.showQRBadge, sender: nil)
            }
          }
        Auth.auth().removeStateDidChangeListener(listener)
    }
    
    @IBAction func loginDidTouch(_ sender: AnyObject) {
        
        guard let email = emailTextField.text,
            let password = passwordTextField.text
            else { return }
        self.submitButton.isEnabled = false
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error == nil {
                self.performSegue(withIdentifier: SegueID.showQRBadge, sender: nil)
            } else if let error = error {
                self.presentAlert(title: "Error", message: error.localizedDescription)
            }
            
            self.submitButton.isEnabled = true
        }
        
    }
    
    @IBAction func resetPasswordDidTouch(_ sender: Any) {
        
        guard let email = emailTextField.text else {
            presentAlert(title: "Error", message: "Please enter your email address first")
            return
        }
        
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if error == nil {
                self.presentAlert(title: "", message: "Please check your mail box for reset password instructions")
            } else if let error = error {
                self.presentAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    @IBAction func viewTapped(_ sender: Any) {
        tableView.endEditing(true)
    }
    
    @IBAction func closeLoginFlow(_ sender: Any) {
        navigationController?.dismiss(animated: true)
    }
    
    private func isScreenValid() -> Bool {
        return emailTextField.isValid(true) &&
            passwordTextField.isValid(true)
    }
    
    private func reloadScreen() {
        submitButton.isEnabled = isScreenValid()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let segueID = segue.identifier else { return }
        
        switch segueID {
        case SegueID.showQRBadge:
            guard let destination = segue.destination as? BusinessQRViewController else { return }
            destination.alreadyRegistered = true
            
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

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        reloadScreen()
    }
    
    
}
