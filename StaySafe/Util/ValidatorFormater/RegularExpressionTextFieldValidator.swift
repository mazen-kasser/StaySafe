//
//  Copyright © 2020 iProgram. All rights reserved.
//

/// Validates against regular expressions
class RegularExpressionTextFieldValidator: TextFieldValidator {

    let mandatory: Bool
    let mandatoryValidationMessage: String
    let invalidValidationMessage: String
    let validationRegex: String
    let userInputValidationRegex: String

    init(mandatory: Bool, mandatoryValidationMessage: String, invalidValidationMessage: String, validationRegex: String, userInputValidationRegex: String) {
        self.mandatory = mandatory
        self.mandatoryValidationMessage = mandatoryValidationMessage
        self.invalidValidationMessage = invalidValidationMessage
        self.validationRegex = validationRegex
        self.userInputValidationRegex = userInputValidationRegex
    }

    /// Validator which uses a fixed regex for both `isValid:` and `isValidUserInput:`
    init(mandatory: Bool, mandatoryValidationMessage: String, invalidValidationMessage: String, validationRegex: String) {
        self.mandatory = mandatory
        self.mandatoryValidationMessage = mandatoryValidationMessage
        self.invalidValidationMessage = invalidValidationMessage
        self.validationRegex = validationRegex
        self.userInputValidationRegex = validationRegex
    }

    /// Validates the given text against the regex, treating nil as empty string, and trimming leading/trailing whitespace
    func isValid(_ text: String?) -> Bool {
        return text.stringified.trimmed.matchesRegex(validationRegex)
    }

    /// Validates the given text against the regex, treating nil as empty string, and trimming leading/trailing whitespace
    func isValidUserInput(_ text: String?) -> Bool {
        return text.stringified.trimmed.matchesRegex(userInputValidationRegex)
    }
}
