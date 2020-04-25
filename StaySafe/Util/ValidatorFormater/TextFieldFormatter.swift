//
//  Copyright © 2020 iProgram. All rights reserved.
//

/// Formats text for display on screen, or for binding to a model object.
protocol TextFieldFormatter {

    /// Converts the text to a format used for displaying on screen
    func formatTextForDisplay(_ text: String?) -> String

    
    /// Converts the text to a String in a format that can be used for the model.
    /// Implementation can assume that the text passed in is already valid as determined by the validator's `isValid:` method
    func formatTextForModel(_ text: String?) -> String
}
