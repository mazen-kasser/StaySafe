//
//  UIView+.swift
//  StaySafe
//
//  Created by Mazen on 11/04/20.
//  Copyright © 2020 iProgram. All rights reserved.
//

import UIKit

@IBDesignable
extension UIView {
    
    @IBInspectable public var cornderRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
}
