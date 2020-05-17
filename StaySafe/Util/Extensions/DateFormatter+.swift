//
//  Copyright © 2020 iProgram. All rights reserved.
//

import Foundation

extension Date {
    
    var formatted: String {
        return DateFormatter.yyyyMMdd.string(from: self)
    }
}

extension DateFormatter {
    
    static let yyyyMMdd: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        formatter.doesRelativeDateFormatting = true
        return formatter
    }()
    
}
