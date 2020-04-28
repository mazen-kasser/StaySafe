//
//  Copyright © 2020 iProgram. All rights reserved.
//

import Foundation

private enum TextValidator {
       enum Name {
           static let mandatoryValidationMessage = NSLocalizedString("Please enter a name", comment: "validation message")
           static let validationMessage = NSLocalizedString( "Please enter a valid name", comment: "validation message")
       }

       enum Mobile {
           static let mandatoryValidationMessage = NSLocalizedString("Please enter a mobile number", comment: "validation message")
           static let validationMessage = NSLocalizedString("Please enter number starting with 02", comment: "validation message")
       }
}

// MARK: Name validation

final class NameTextFieldValidator: RegularExpressionTextFieldValidator {
    init() {
        super.init(mandatory: true,
                   mandatoryValidationMessage: TextValidator.Name.mandatoryValidationMessage,
                   invalidValidationMessage: TextValidator.Name.validationMessage,
                   validationRegex: "^[a-zA-Z][- 'a-zA-Z0-9]{0,59}$",
                   userInputValidationRegex: "^.{1,30}$")
    }
}

final class NameTextFieldFormatter: RegularExpressionTextFieldFormatter {
    init() {
        super.init(invalidCharactersRegex: "[^- 'a-zA-Z0-9]")
    }

    override func formatTextForDisplay(_ text: String?) -> String {
        return text.stringified.trimmed
    }
}

// MARK: Mobile validation

final class MobileTextFieldValidator: RegularExpressionTextFieldValidator {
    init() {
        super.init(mandatory: true,
                   mandatoryValidationMessage: TextValidator.Mobile.mandatoryValidationMessage,
                   invalidValidationMessage: TextValidator.Mobile.validationMessage,
                   validationRegex: "^02[0-9]{7,9}$",
                   userInputValidationRegex: "^[0-9]{1,11}$")
    }
}

final class MobileTextFieldFormatter: RegularExpressionTextFieldFormatter {
    init() {
        super.init(invalidCharactersRegex: "[^0-9]")
    }

    override func formatTextForDisplay(_ text: String?) -> String {
        return text.stringified.trimmed
    }
}
