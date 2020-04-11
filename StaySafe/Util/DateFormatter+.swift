//
//  DateFormatter+.swift
//  StaySafe
//
//  Created by Mazen on 11/04/20.
//  Copyright © 2020 iProgram. All rights reserved.
//

import Foundation

extension DateFormatter {
    
    static let yyyyMMdd: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        formatter.doesRelativeDateFormatting = true
        return formatter
    }()
    
}
