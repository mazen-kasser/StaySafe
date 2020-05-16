//
//  Copyright © 2020 iProgram. All rights reserved.
//

import Foundation

enum BusinessValidationRule: String, ValidationRule {
    case name = "BusinessName"
    case address = "BusinessAddress"
    case email = "Email"
    case password = "Password"

    static var rules: [ValidationRule] {
        return [
            BusinessValidationRule.name,
            BusinessValidationRule.address,
            BusinessValidationRule.email,
            BusinessValidationRule.password
        ]
    }

    var validatorFormatter: ValidatorFormatter {
        switch self {
        case .name:
            return ValidatorFormatterTextFieldDelegate(BusinessNameTextFieldValidator(), BusinessNameTextFieldFormatter())
        case .address:
            return ValidatorFormatterTextFieldDelegate(BusinessAddressTextFieldValidator(), BusinessAddressTextFieldFormatter())
        case .email:
            return ValidatorFormatterTextFieldDelegate(BusinessEmailTextFieldValidator(), BusinessEmailTextFieldFormatter())
        case .password:
            return ValidatorFormatterTextFieldDelegate(BusinessPasswordTextFieldValidator(), BusinessPasswordTextFieldFormatter())
        }
    }
}
