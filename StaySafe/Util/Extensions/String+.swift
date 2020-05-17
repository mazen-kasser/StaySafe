//
//  Copyright © 2020 iProgram. All rights reserved.
//

import Foundation

extension String {
    
    /// Returns a new string made by removing from both ends of the String all whitespace and newline characters (whitespaceAndNewlineCharacterSet)
    public var trimmed: String {
        return trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }

    /// Mutates the existing string, removing from both ends of the String all whitespace and newline characters (whitespaceAndNewlineCharacterSet)
    public mutating func trim() {
        self = trimmed
    }
    
    /// Returns true if string is blank, i.e. consists of whitespace characters only.
    var isBlank: Bool {
        return trimmed.isEmpty
    }
}

extension String {
    
    /// The full range of the string, from startIndex to endIndex.
    public var rangeToEnd: Range<String.Index> {
        return (startIndex)..<(endIndex)
    }
    
    /// Returns a new String where all matches against the regex in the entire string are removed.
    public func stringByRemovingRegexMatches(_ regex: String) -> String {
        return replacingOccurrences(of: regex, with: "", options: .regularExpression, range: rangeToEnd)
    }
    
    /// Whether there is at least one match in this string for the given regular expressions
    func matchesRegex(_ regex: String) -> Bool {
        return matchesRegex(regex, isCaseInsensitive: false)
    }

    /// Whether there is at least one match in this string for the given regular expressions
    func matchesRegex(_ regex: String, isCaseInsensitive: Bool) -> Bool {
        let options: NSString.CompareOptions
        if isCaseInsensitive {
            options = [.regularExpression, .caseInsensitive]
        } else {
            options = .regularExpression
        }
        return range(of: regex, options: options) != nil
    }

    /// Whether there is at least one match in this string for any of the given regular expressions
    func matchesAnyRegex(_ regexList: [String]) -> Bool {
        return matchesAnyRegex(regexList, isCaseInsensitive: false)
    }

    /// Whether there is at least one match in this string for any of the given regular expressions with the specified CaseInsensitive option
    func matchesAnyRegex(_ regexList: [String], isCaseInsensitive: Bool) -> Bool {
        for regex in regexList {
            if self.matchesRegex(regex, isCaseInsensitive: isCaseInsensitive) {
                return true
            }
        }
        return false
    }
    
}

/// Phantom type for optionals wrapping a `String`.
protocol OptionalString {}
extension String: OptionalString {}

extension Optional where Wrapped: OptionalString {

    /// Check if the string is either `nil` or empty.
    var isNilOrEmpty: Bool {
        return stringified.isEmpty
    }

    /// Check if the string is either `nil` or blank.
    var isNilOrBlank: Bool {
        return stringified.isBlank
    }
    
    /// If the string is `nil` returns an empty one, otherwise self.
    var stringified: String {
        return ifNil("")
    }
    
    /// Map string to a new value if receiver is `nil`.
    func ifNil(_ closure: @autoclosure () -> String) -> String {
        return (self as? String) ?? closure()
    }
}
