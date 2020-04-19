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
    
    @discardableResult
    func loadAndAddSubviewFromNib() -> UIView {
        return loadAndAddSubviewFromNib(name: String(describing: type(of: self)))
    }

    private func loadAndAddSubviewFromNib(name: String) -> UIView {
        let klass = type(of: self)
        let bundle = Bundle(for: klass)
        let nib = UINib(nibName: name, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        return view
    }
    
}
