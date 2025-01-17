//
//  Copyright © 2020 iProgram. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class CustomBusinessViewController: UITableViewController {

    @IBOutlet private weak var submitButton: UIButton!
    @IBOutlet private weak var nameTextField: CATextField!
    @IBOutlet private weak var addressTextField: CATextField!
    
    enum SegueID {
        static let showQRBadge = "showBusinessQRViewController"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    @IBAction func submitDidTouch(_ sender: Any) {
        
        let deviceToken = UserDefaults.standard.deviceToken ?? ""
        let emailAddress = Auth.auth().currentUser?.email ?? ""
        
        guard let businessName = nameTextField.text,
            let businessAddress = addressTextField.text
            else { return }
        
        Firestore.firestore().collection("businessAccounts").document(emailAddress).setData([
            "deviceToken": deviceToken,
            "businessAddress": businessAddress,
            "businessName": businessName,
            "createdAt": Date().formatted
        ]) { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.performSegue(withIdentifier: SegueID.showQRBadge, sender: sender)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        guard let segueID = segue.identifier else { return }

        switch segueID {
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
