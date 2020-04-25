//
//  Copyright © 2020 iProgram. All rights reserved.
//

/**
This represents a validation and formatting rule for a textfield,
and provides a friendly API to reference the rule through code, or through an IBInspectable String property.

It is recommended that the concrete implementation be a `String` enum,
and the cases represent all the validation/formatting rules for the business domain.
You will typically define one of these enums for each module.

For example:

    enum MyValidationRule: String, ValidationRule {

        case Amount = "MyAmount"

        static var rules: [ValidationRule] {
            return [
                MyValidationRule.Amount
            ]
        }

        var validatorFormatter: ValidatorFormatter {
            switch self {
            case .Amount:
                return ValidatorFormatterTextFieldDelegate(AmountTextFieldValidator(), AmountTextFieldFormatter())
            }
        }
    }

*/

protocol ValidationRule {

    /// List of every rule in this enum
    static var rules: [ValidationRule] { get }

    /// The raw value of the String enum
    var rawValue: String { get }

    /**
    Factory method which map each case of the enum to a concrete `ValidatorFormatterTextFieldDelegate`
    which does the actual validation and formatting logic.
    */
    var validatorFormatter: ValidatorFormatter { get }
}
