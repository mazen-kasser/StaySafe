//
//  Copyright © 2020 iProgram. All rights reserved.
//

import Foundation

enum BusinessValidationRule: String, ValidationRule {
    case name = "BusinessName"
    case address = "BusinessAddress"

    static var rules: [ValidationRule] {
        return [
            BusinessValidationRule.name,
            BusinessValidationRule.address
        ]
    }

    var validatorFormatter: ValidatorFormatter {
        switch self {
        case .name:
            return ValidatorFormatterTextFieldDelegate(BusinessNameTextFieldValidator(), BusinessNameTextFieldFormatter())
        case .address:
            return ValidatorFormatterTextFieldDelegate(BusinessAddressTextFieldValidator(), BusinessAddressTextFieldFormatter())
        }
    }
}
