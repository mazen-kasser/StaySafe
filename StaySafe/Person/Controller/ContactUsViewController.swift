//
//  Copyright © 2020 iProgram. All rights reserved.
//

import UIKit

class ContactUsViewController: UITableViewController {

    @IBOutlet private weak var submitButton: UIButton!
    @IBOutlet private weak var contactNameTextField: CATextField!
    @IBOutlet private weak var mobileNumberTextField: CATextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addDoneButtonOnKeyboard()
    }

    @IBAction func submitButtonTapped(_ sender: Any) {
        guard isScreenValid() else { return }
        
        presentAlert(title: "Submit only if you have been contacted by authorised person",
                     message: "We will be in touch shortly if further details are required",
                     isCancellable: true,
                     style: .actionSheet) { _ in
            // TODO: API call
            Alert.showLoading (title: "") { [weak self] in
                Alert.hideLoading()
                self?.closeButtonTapped()
            }
        }
    }
    
    @IBAction func closeButtonTapped() {
        navigationController?.dismiss(animated: true)
    }

    @IBAction func viewTapped(_ sender: Any) {
        tableView.endEditing(true)
    }

    private func isScreenValid() -> Bool {
        return contactNameTextField.isValid(true) &&
            mobileNumberTextField.isValid(true)
    }
    
    private func reloadScreen() {
        submitButton.isEnabled = isScreenValid()
    }
    
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                        target: nil,
                                        action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done",
                                                    style: .done,
                                                    target: self,
                                                    action: #selector(self.doneButtonAction))

        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        mobileNumberTextField.inputAccessoryView = doneToolbar
    }

    @objc func doneButtonAction() {
        mobileNumberTextField.resignFirstResponder()
        reloadScreen()
    }

}

extension ContactUsViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        mobileNumberTextField.becomeFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        reloadScreen()
    }
}
