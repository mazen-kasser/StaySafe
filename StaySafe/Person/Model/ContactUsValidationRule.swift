//
//  Copyright © 2020 iProgram. All rights reserved.
//

import Foundation

enum ContactUsValidationRule: String, ValidationRule {
    case participantName = "ParticipantName"
    case participantMobile = "ParticipantMobile"

    static var rules: [ValidationRule] {
        return [
            ContactUsValidationRule.participantName,
            ContactUsValidationRule.participantMobile
        ]
    }

    var validatorFormatter: ValidatorFormatter {
        switch self {
        case .participantName:
            return ValidatorFormatterTextFieldDelegate(NameTextFieldValidator(), NameTextFieldFormatter())
        case .participantMobile:
            return ValidatorFormatterTextFieldDelegate(MobileTextFieldValidator(), MobileTextFieldFormatter())
        }
    }
}
