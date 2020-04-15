//  Copyright © 2019 iProgram. All rights reserved.

import UIKit


/// A `UITextFieldDelegate` which is responsible for preventing invalid user input,
/// for formatting the text to a display version (when editing ends),
/// and restoring the text back to the original one the user typed in (when editing begins)
protocol ValidatorFormatter: UITextFieldDelegate {

    /// The validator which provides the rules for whether a textfield is valid
    var validator: TextFieldValidator { get }

    /// The formatter which formats text for display on screen, or for binding to a model object.
    var formatter: TextFieldFormatter { get }

    
    /// `UITextFieldDelegate` which is called after this class is finished.
    /// This will usually be the ViewController which conforms to `UITextFieldDelegate`
    /// which wants to perform some logic for the text field besides the validation.
    /// This is set automatically by `CBATextField`.
    var chainedDelegate: UITextFieldDelegate? { get set }

    /// The original text the user typed into the textfield
    var originalText: String? { get set }
}

/// A concrete`ValidatorFormatter` which is responsible for preventing invalid user input,
/// for formatting the text to a display version (when editing ends),
/// and restoring the text back to the original one the user typed in (when editing begins)
class ValidatorFormatterTextFieldDelegate: NSObject, ValidatorFormatter {

    /// The validator which provides the rules for whether a textfield is valid
    let validator: TextFieldValidator

    /// The formatter which formats text for display on screen, or for binding to a model object.
    let formatter: TextFieldFormatter

    /// The original text the user typed into the textfield
    var originalText: String?

    /// `UITextFieldDelegate` which is called after this class is finished.
    /// This will usually be the ViewController which conforms to `UITextFieldDelegate`
    /// which wants to perform some logic for the text field besides the validation.
    /// This is set automatically by `CATextField`.
    weak var chainedDelegate: UITextFieldDelegate?

    // MARK: Constructors

    init(_ validator: TextFieldValidator, _ formatter: TextFieldFormatter) {
        self.validator = validator
        self.formatter = formatter
        super.init()
    }

    // MARK: - UITextFieldDelegate

    // after applying validation/formatting logic, calls the chained delegate

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let text = textField.text ?? ""
        let newString = (text as NSString).replacingCharacters(in: range, with: string)

        var shouldChange: Bool

        if string.isEmpty {
            shouldChange = true  // all deletions allowed
        } else {
            shouldChange = validator.isValidUserInput(newString)
        }

        // if we think it's valid here, let the chained delegate decide, or default to true
        if shouldChange {
            shouldChange = chainedDelegate?.textField?(textField, shouldChangeCharactersIn: range, replacementString: string) ?? true
        }

        if shouldChange {

            // formatTextWhileTyping
            if let cbaTextField = textField as? CATextField, cbaTextField.formatTextWhileTyping {
                let formattedText = self.formatter.formatTextForDisplay(newString)
                originalText = formattedText
                DispatchQueue.main.async {
                    cbaTextField.text = formattedText
                }
            } else {
                originalText = newString
            }

            // validate as we type, which makes it look valid if validation passes
            if let cbaTextField = textField as? CATextField {
                let _ = try? cbaTextField.validate()
            }
        }

        return shouldChange
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        let result = chainedDelegate?.textFieldShouldClear?(textField) ?? true
        if result {
            originalText = ""
        }
        return result
    }

    // MARK: Passthrough delegate methods
    // the following delegate methods just get forwarded to the chained delegate

    func textFieldDidBeginEditing(_ textField: UITextField) {
        chainedDelegate?.textFieldDidBeginEditing?(textField)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        chainedDelegate?.textFieldDidEndEditing?(textField)
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return chainedDelegate?.textFieldShouldBeginEditing?(textField) ?? true
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return chainedDelegate?.textFieldShouldEndEditing?(textField) ?? true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return chainedDelegate?.textFieldShouldReturn?(textField) ?? true
    }

    // MARK: - Begin and End Editing
    // Because the CBATextField also listens for these notifications, let it be responsible for control flow. Otherwise, the order might be indeterminant.

    /// Replaces the text with what was originally there before formatting. Should be called when editing begins.
    func replaceWithOriginalText(_ textField: UITextField) {
        textField.text = originalText
    }

    /// Applies the formatting to the textfield, and saving the current text so it can be restored. Should be called when editing ends.
    func formatTextInTextField(_ textField: UITextField) {
        let savedText = textField.text
        textField.text = formatter.formatTextForDisplay(textField.text)  // property observer for `text` will change `originalText`
        originalText = savedText // so replace it here
    }
}
