//  Copyright © 2019 iProgram. All rights reserved.

import UIKit

class CATextFieldValidationLabel: UILabel {

    private struct Constants {
        static let topMargin: CGFloat = 12.0
        static let animationDuration: TimeInterval = 0.3
    }

    weak var textField: CATextField! {
        didSet {
//            styleDefinition = textField.styleDefinition
        }
    }

    // MARK: Init and setup

    init(textField: CATextField) {
        self.textField = textField
        super.init(frame: CGRect.zero)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func setupView() {
        guard let superview = textField.superview else { return }
        superview.addSubview(self)

        numberOfLines = 0
        translatesAutoresizingMaskIntoConstraints = false
        alpha = 0.0
//        isAccessibilityElement = false

        let widthConstraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: textField, attribute: .width, multiplier: 1.0, constant: 0)
        let topMarginConstraint = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: textField, attribute: .bottom, multiplier: 1.0, constant: Constants.topMargin)
        let leadingConstraint = NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: textField, attribute: .leading, multiplier: 1.0, constant: 0)
        NSLayoutConstraint.activate([widthConstraint, topMarginConstraint, leadingConstraint])
    }

    func showError(_ message: String) {
        text = message
        UIView.animate(withDuration: Constants.animationDuration, delay: 0, animations: {
            self.alpha = 1.0
        }, completion: nil)
    }

    func hideError(_ animated: Bool = true) {
        if animated {
            UIView.animate(withDuration: Constants.animationDuration, delay: 0, animations: {
                self.alpha = 0.0
            }) { _ in
                self.text = nil
            }
        } else {
            alpha = 0.0
            text = nil
        }
    }

}
