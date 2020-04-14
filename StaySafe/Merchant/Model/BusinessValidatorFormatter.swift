//
//  ContactUsValidatorFormatter.swift
//  StaySafe
//
//  Created by Mazen on 13/04/20.
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
