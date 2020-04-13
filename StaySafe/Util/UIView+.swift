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
    
    /// To load SomeView from a nib named SomeView.xib:
    ///
    /// let aView: SomeView = .loadFromNib()
    class func loadFromNib<T: UIView>() -> T {
        let bundle = Bundle(for: T.self)
        return bundle.loadNibNamed(String(describing: T.self), owner: nil, options: nil)!.first as! T
    }
    
}
