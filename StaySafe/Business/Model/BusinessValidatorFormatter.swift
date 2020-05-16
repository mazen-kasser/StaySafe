//
//  Copyright © 2020 iProgram. All rights reserved.
//

import Foundation

private enum TextValidator {
    enum Name {
        static let mandatoryValidationMessage = NSLocalizedString("Please enter a name", comment: "validation message")
        static let validationMessage = NSLocalizedString( "Please enter a valid name", comment: "validation message")
    }
    
    enum Business {
        static let mandatoryValidationMessage = NSLocalizedString("Please enter an address", comment: "validation message")
        static let validationMessage = NSLocalizedString("Please enter a valid address starting with a number", comment: "validation message")
    }
    
    enum Email {
        static let mandatoryValidationMessage = NSLocalizedString("Please enter your email address", comment: "validation message")
        static let validationMessage = NSLocalizedString("Please enter a valid email address", comment: "validation message")
    }
}

// MARK: Name validation

final class BusinessNameTextFieldValidator: RegularExpressionTextFieldValidator {
    init() {
        super.init(mandatory: true,
                   mandatoryValidationMessage: TextValidator.Name.mandatoryValidationMessage,
                   invalidValidationMessage: TextValidator.Name.validationMessage,
                   validationRegex: "^[a-zA-Z0-9][- 'a-zA-Z0-9]{0,59}$",
                   userInputValidationRegex: "^.{1,30}$")
    }
}

final class BusinessNameTextFieldFormatter: RegularExpressionTextFieldFormatter {
    init() {
        super.init(invalidCharactersRegex: "[^- 'a-zA-Z0-9]")
    }

    override func formatTextForDisplay(_ text: String?) -> String {
        return text.stringified.trimmed
    }
}

// MARK: Mobile validation

final class BusinessAddressTextFieldValidator: RegularExpressionTextFieldValidator {
    init() {
        super.init(mandatory: true,
                   mandatoryValidationMessage: TextValidator.Business.mandatoryValidationMessage,
                   invalidValidationMessage: TextValidator.Business.validationMessage,
                   validationRegex: "^[0-9][- ,'a-zA-Z0-9]{0,59}$",
                   userInputValidationRegex: "^.{1,60}$")
    }
}

final class BusinessAddressTextFieldFormatter: RegularExpressionTextFieldFormatter {
    init() {
        super.init(invalidCharactersRegex: "[^- ,'a-zA-Z0-9]")
    }

    override func formatTextForDisplay(_ text: String?) -> String {
        return text.stringified.trimmed
    }
}

// MARK: Email validation

final class BusinessEmailTextFieldValidator: RegularExpressionTextFieldValidator {
    init() {
        super.init(mandatory: true,
                   mandatoryValidationMessage: TextValidator.Email.mandatoryValidationMessage,
                   invalidValidationMessage: TextValidator.Email.validationMessage,
                   validationRegex: "^[a-zA-Z0-9][a-zA-Z0-9-_.]*@[a-zA-Z0-9-]+(\\.[a-zA-Z0-9-]+)*(\\.[a-zA-Z]{2,4})$",
                   userInputValidationRegex: "^.{1,80}$")
    }
}

final class BusinessEmailTextFieldFormatter: RegularExpressionTextFieldFormatter {
    init() {
        super.init(invalidCharactersRegex: "")
    }

    override func formatTextForDisplay(_ text: String?) -> String {
        return text.stringified.trimmed
    }
}

// MARK: Password validation

final class BusinessPasswordTextFieldValidator: NSObject, TextFieldValidator {
    private struct Strings {
        static let mandatoryValidationMessage = NSLocalizedString("You must set a password", comment: "validation message")
        static let invalidCharsValidationMessage = NSLocalizedString("Your password must not contain the characters < > ^ ` { } ~ = ;", comment: "validation message")
        static let whitelistValidationMessage = NSLocalizedString("Please enter letters, numbers and spaces only.", comment: "validation message")
        static let digitCharsValidationMessage = NSLocalizedString("Your password must be made up of letters and at least one number.", comment: "validation message")
        static let lengthValidationMessage = NSLocalizedString("Your password must be between 8 and 16 characters. Please choose a longer password.", comment: "validation message")
    }

    private struct PasswordConstants {
        static let whitelistRegex = "^[\\w!@#$%&*()_' |\":,+\\/\\.\\]\\[\\-\\?\\\\]+$"
        static let invalidCharSet = "<>^`{}~=;"
        static let digitsRegex = "\\d"
        static let alphaRegex = "[a-zA-Z]"
        static let userInputValidationRegex = "^.{1,16}$"
        static let minLength = 8
    }

    let mandatory = true
    let mandatoryValidationMessage = Strings.mandatoryValidationMessage
    let invalidValidationMessage = ""
    
    override init() {}

    func isValid(_ text: String?) -> Bool {
        guard let _ = try? validate(text) else { return false }
        return true
    }

    func isValidUserInput(_ text: String?) -> Bool {
        guard let text = text, !text.isEmpty else { return false }

        return text.matchesRegex(PasswordConstants.userInputValidationRegex)
    }

    func validate(_ text: String?) throws {
        let trimmed = text.stringified.trimmed

        if trimmed.isEmpty {
            throw ValidationError(message: Strings.mandatoryValidationMessage)
        } else if trimmed.count < PasswordConstants.minLength {
            throw ValidationError(message: Strings.lengthValidationMessage)
        } else if let _ = trimmed.rangeOfCharacter(from: CharacterSet(charactersIn: PasswordConstants.invalidCharSet)) {
            throw ValidationError(message: Strings.invalidCharsValidationMessage)
        } else if !trimmed.matchesRegex(PasswordConstants.whitelistRegex) {
            throw ValidationError(message: Strings.whitelistValidationMessage)
        } else if !trimmed.matchesRegex(PasswordConstants.digitsRegex) || !trimmed.matchesRegex(PasswordConstants.alphaRegex) {
            throw ValidationError(message: Strings.digitCharsValidationMessage)
        }
    }
}

final class BusinessPasswordTextFieldFormatter: RegularExpressionTextFieldFormatter {
    init() {
        super.init(invalidCharactersRegex: "")
    }

    override func formatTextForDisplay(_ text: String?) -> String {
        return text.stringified.trimmed
    }
}
