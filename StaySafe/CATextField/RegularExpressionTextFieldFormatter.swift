//  Copyright © 2019 iProgram. All rights reserved.

class RegularExpressionTextFieldFormatter: TextFieldFormatter {

    let invalidCharactersRegex: String

    init(invalidCharactersRegex: String) {
        self.invalidCharactersRegex = invalidCharactersRegex
    }

    func formatTextForDisplay(_ text: String?) -> String {
        return trimAndCleanText(text)
    }

    func formatTextForModel(_ text: String?) -> String {
        return trimAndCleanText(text)
    }

    /// Returns the String after trimming whitespace and removing invalid characters from the given String
    func trimAndCleanText(_ text: String?) -> String {
        return text?.trimmed.stringByRemovingRegexMatches(invalidCharactersRegex) ?? ""
    }
}
