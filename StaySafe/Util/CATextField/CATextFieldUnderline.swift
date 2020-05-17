//
//  Copyright © 2020 iProgram. All rights reserved.
//

import UIKit

class CATextFieldUnderline: UIView {

    // MARK: Constants

    private struct Constants {
        static let thinLineHeight: CGFloat = 1.0
        static let thickLineHeight: CGFloat = 2.0
        static let topMargin: CGFloat = 4.0
        static let animationDuration: TimeInterval = 0.3
    }

    // MARK: Styling

//    var styleDefinition: CBATextFieldStyleDefinition {
//        didSet {
//            updateLineColor()
//        }
//    }

    // MARK: Private properties

    private weak var textField: CATextField!
    private var constraintToAnimate: NSLayoutConstraint!

    // MARK: Init and setup

    init(textField: CATextField) {
        self.textField = textField
//        styleDefinition = textField.styleDefinition
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not supported for CATextFieldUnderline")
    }

    private func setupView() {
        guard let superview = textField.superview else { return }
        superview.addSubview(self)

        clipsToBounds = true
        updateLineColor()
        translatesAutoresizingMaskIntoConstraints = false

        let heightConstraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: Constants.thinLineHeight)
        constraintToAnimate = heightConstraint

        let widthConstraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: textField, attribute: .width, multiplier: 1.0, constant: 0)

        let topMarginConstraint = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: textField, attribute: .bottom, multiplier: 1.0, constant: Constants.topMargin)

        let leadingConstraint = NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: textField, attribute: .leading, multiplier: 1.0, constant: 0)

        NSLayoutConstraint.activate([heightConstraint, widthConstraint, topMarginConstraint, leadingConstraint])
    }

    // MARK: Line styling

    /// When highlighted is true, the line style indicates that the textfield is being edited.
    var highlighted = false {
        didSet {
            if oldValue != highlighted {
                updateLineAnimated()
            }
        }
    }

    /// When valid is false, the line style indicates that the textfield is invalid. When valid is true, the highlighted property determines the line style.
    var valid = true {
        didSet {
            if oldValue != valid {
                updateLineAnimated()
            }
        }
    }

    private func updateLineColor() {
        if !valid {
            backgroundColor = .systemRed
        } else {
            backgroundColor = highlighted ? UIColor(white: 0.0, alpha: 0.1) : UIColor(white: 0.0, alpha: 0.1)
        }
    }

    private func updateLineHeight() {
        if !valid {
            constraintToAnimate.constant = Constants.thickLineHeight
        } else {
            constraintToAnimate.constant = highlighted ? Constants.thickLineHeight : Constants.thinLineHeight
        }
        setNeedsUpdateConstraints()
    }

    private func updateLineAnimated() {
        updateLineHeight()
        UIView.animate(withDuration: Constants.animationDuration, delay: 0, animations: {
            self.updateLineColor()
        }, completion: nil)
    }
}
