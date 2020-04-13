//  Copyright © 2019 iProgram. All rights reserved.

import Foundation

/// Stores every `ValidationRule` in the app, so that you can create any of them using the raw `String` value.
struct ValidationRulesRegistry {
    private (set) static var registry = [String: ValidationRule]()

    /// Rules registry errors.
    enum RegistryError: Error {
        /// Rule already exists in the registry.
        case ruleAlreadyExists(String)

        /// Rule with the given raw value is not registered.
        case ruleNotRegistered(String)
    }

    /// Adds validation rules into the rules registry.
    ///
    /// There should be a single place in the app where all the validation rules are registered.
    /// Registering a rule should look something like this:
    ///
    ///     ValidationRulesRegistry.addRulesToRegistry(MyValidationRule.rules)
    ///
    /// - Parameter rules: Rules to add to the registry
    /// - Throws: RegistryError.ruleAlreadyExists if another rule has already registered the raw `String` value.
    static func addRulesToRegistry(_ rules: [ValidationRule]) throws {
        for rule in rules {
            let keyExists = registry.contains { (key, _) in
                return rule.rawValue == key
            }
            guard !keyExists else { throw RegistryError.ruleAlreadyExists(rule.rawValue) }
            registry[rule.rawValue] = rule
        }
    }

    ///  Fatal error if the rule cannot be found (or returns nil in release build).

    /// Finds the `ValidationRule` which has the given raw `String` value.
    ///
    /// - Parameter rawValue: Rule raw value.
    /// - Returns: Validaton rule for the given raw value.
    /// - Throws: RegistryError.ruleAlreadyExists
    static func ruleFromRawValue(_ rawValue: String) throws -> ValidationRule {
        guard let result = registry[rawValue] else { throw RegistryError.ruleNotRegistered(rawValue) }
        return result
    }
}
