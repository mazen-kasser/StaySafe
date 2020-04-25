//
//  Copyright © 2020 iProgram. All rights reserved.
//

import Foundation

/// Provides the rules for whether a textfield is valid
protocol TextFieldValidator {

    /// Whether the field is mandatory.
    var mandatory: Bool { get }

    /// Validation message shown to user when field is blank
    var mandatoryValidationMessage: String { get }

    /// Validation message shown to user when the field is invalid
    var invalidValidationMessage: String { get }

    /// Whether the text is considered valid
    func isValid(_ text: String?) -> Bool


    /// Whether the text is considered valid for user input.
    /// This is often a partial incomplete input, which should be allowed, but would not be valid overall.
    /// For example, for amounts, 0.0 is valid for user input (allowing user to type 0.01), but should still trigger a validation error.
    func isValidUserInput(_ text: String?) -> Bool

    /// Performs validation, throwing the appropriate validation error (which includes the validation message) when validation fails
    func validate(_ text: String?) throws
}

extension TextFieldValidator {

    /// default implementation checks mandatory and checks isValid:
    func validate(_ text: String?) throws {
        guard !text.isNilOrBlank else {
            if mandatory {
                throw ValidationError(message: mandatoryValidationMessage)
            }
            return
        }

        guard isValid(text) else { throw ValidationError(message: invalidValidationMessage) }
    }
}

/// Represents a validation error
struct ValidationError: Error {
    let domain = "ValidationError"
    let code: Int
    let message: String
    let title = ""

    init(code: Int = 1, message: String) {
        self.code = code
        self.message = message
    }
}
