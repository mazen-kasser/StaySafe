//
//  Copyright © 2020 iProgram. All rights reserved.
//

import UIKit

class ContactUsViewController: UITableViewController {

    @IBOutlet private weak var submitButton: UIButton!
    @IBOutlet private weak var contactNameTextField: CATextField!
    @IBOutlet private weak var mobileNumberTextField: CATextField!
    
    private var viewModel = ContactUsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addDoneButtonOnKeyboard()
    }

    @IBAction func submitButtonTapped(_ sender: Any) {
        guard isScreenValid() else { return }
        
        presentAlert(title: "Please make sure the details provided are correct",
                     message: "As we may need to contact you in case of protecting your safety",
                     actionTitle: "Done",
                     isCancellable: true,
                     style: .actionSheet) { [weak self] _ in
                        guard let self = self else { return }
                        
                        self.viewModel.save(fullName: self.contactNameTextField.text,
                                            mobileNumber: self.mobileNumberTextField.text)
                        
                        Alert.showLoading (title: "") { [weak self] in
                            Alert.hideLoading()
                            
                            self?.showNextFlow()
                        }
        }
    }
    
    private func showNextFlow() {
        let storyboard = Storyboard.person.instance
        let rootViewController = storyboard.instantiateInitialViewController()!
        rootViewController.modalPresentationStyle = .fullScreen
        present(rootViewController, animated: true)
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
