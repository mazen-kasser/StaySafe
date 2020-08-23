//
//  Copyright © 2020 iProgram. All rights reserved.
//

import UIKit

class CATextFieldFloatingLabel {

    private struct Constants {
        static let marginToTextField: CGFloat = 0.0
        static let placeholderYStartingOffset: CGFloat = 1.0
        static let animationDuration: TimeInterval = 0.2
    }

    // MARK: Private properties

    private weak var textField: CATextField?
    private weak var superview: UIView?
    private var floatingLabel: UILabel!
    private var placeholderAnimationLabel: UILabel!
    private var constraintYToAnimate: NSLayoutConstraint!
    private var constraintXToAnimate: NSLayoutConstraint?
    private weak var leadingConstraintToRemove: NSLayoutConstraint?

    // MARK: Init and setup

    init?(textField: CATextField) {
        guard let superview = textField.superview else { return nil }

        self.superview = superview
        self.textField = textField
        floatingLabel = UILabel(frame: .zero)
        placeholderAnimationLabel = UILabel(frame: .zero)

        setupFloatingLabel(superview)
        setupPlaceholderAnimationLabel(superview)
    }

    private func setupFloatingLabel(_ superview: UIView) {
        guard let textField = textField else { return }
        superview.addSubview(floatingLabel)
        setupLabel(floatingLabel)

        let bottomMarginConstraint = NSLayoutConstraint(item: textField, attribute: .top, relatedBy: .equal, toItem: floatingLabel, attribute: .bottom, multiplier: 1.0, constant: Constants.marginToTextField)
        let leadingConstraint = NSLayoutConstraint(item: floatingLabel, attribute: .leading, relatedBy: .equal, toItem: textField, attribute: .leading, multiplier: 1.0, constant: 0)
        NSLayoutConstraint.activate([bottomMarginConstraint, leadingConstraint])
    }

    private func setupPlaceholderAnimationLabel(_ superview: UIView) {
        guard let textField = textField else { return }
        
        superview.addSubview(placeholderAnimationLabel)
        setupLabel(placeholderAnimationLabel)

        let leadingConstraint = NSLayoutConstraint(item: placeholderAnimationLabel, attribute: .leading, relatedBy: .equal, toItem: textField, attribute: .leading, multiplier: 1.0, constant: 0)
        leadingConstraintToRemove = leadingConstraint

        let centerYConstraint = NSLayoutConstraint(item: placeholderAnimationLabel, attribute: .centerY, relatedBy: .equal, toItem: textField, attribute: .centerY, multiplier: 1.0, constant: Constants.placeholderYStartingOffset)
        constraintYToAnimate = centerYConstraint

        NSLayoutConstraint.activate([leadingConstraint, centerYConstraint])
    }

    private func setupLabel(_ label: UILabel) {
        label.text = textField?.placeholder
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.alpha = 0.0
        label.isAccessibilityElement = false
    }

    // MARK: Public API

    var text: String? {
        didSet {
            floatingLabel.text = text
            placeholderAnimationLabel.text = text
        }
    }

    var hidden: Bool = false {
        didSet {
            floatingLabel.isHidden = hidden
            placeholderAnimationLabel.isHidden = hidden
        }
    }

    var floatingLabelAccessibilityLabel: String? {
        didSet { floatingLabel.accessibilityLabel = floatingLabelAccessibilityLabel }
    }

    func removeFromSuperview() {
        floatingLabel.removeFromSuperview()
        placeholderAnimationLabel.removeFromSuperview()
    }

    private var centerDifference: CGFloat = 0

    /// Morphs the placeholder into a floating label
    func showFloatingLabel() {
        guard let textField = textField else { return }

        // if there is already text, then show the label straight away
        // (however, we still proceed with the animation so that we can do the hide properly later)
        if !textField.text.isNilOrEmpty {
            floatingLabel.alpha = 1.0
        }

        // convert to using a center constraint which can be animated
        if constraintXToAnimate == nil {
            textField.superview?.layoutIfNeeded()  // do layout
            centerDifference = placeholderAnimationLabel.center.x - floatingLabel.center.x  // work out an equivalent center constraint
            leadingConstraintToRemove?.isActive = false
            constraintXToAnimate = NSLayoutConstraint(item: placeholderAnimationLabel, attribute: .centerX, relatedBy: .equal, toItem: floatingLabel, attribute: .centerX, multiplier: 1.0, constant: centerDifference)
            constraintXToAnimate?.isActive = true
        }

        // animate the placeholderAnimationLabel, morphing it to the floating label
        // (only needs to be visible when real placeholder is currently shown)
        if textField.text.isNilOrEmpty {
            placeholderAnimationLabel.alpha = 1.0
        }

        // animation
        constraintYToAnimate.constant = -(textField.center.y - floatingLabel.center.y)
        constraintXToAnimate?.constant = 0
        superview?.setNeedsUpdateConstraints()
        UIView.animate(withDuration: Constants.animationDuration, delay: 0, animations: { [weak self] in
            guard let this = self else { return }

            this.superview?.layoutIfNeeded()

            let scale = this.floatingLabel.bounds.width / this.placeholderAnimationLabel.bounds.width
            this.placeholderAnimationLabel.transform = CGAffineTransform(scaleX: scale, y: scale)

        }) { [weak self] _ in
            guard let this = self else { return }
            // show the floating label, and hide the animated label
            this.floatingLabel.alpha = 1.0
            this.placeholderAnimationLabel.alpha = 0.0
        }
    }

    /// Morphs the floating label back to a placeholder
    func hideFloatingLabel(_ completion: (() -> Void)? = nil) {
        // hide the floating label and use the animated label in its place
        self.placeholderAnimationLabel.alpha = 1.0
        self.floatingLabel.alpha = 0.0

        // animation
        self.constraintYToAnimate.constant = Constants.placeholderYStartingOffset
        self.constraintXToAnimate?.constant = centerDifference
        superview?.setNeedsUpdateConstraints()
        UIView.animate(withDuration: Constants.animationDuration, delay: 0, animations: { [weak self] in
            guard let this = self else { return }
            this.superview?.layoutIfNeeded()
            this.placeholderAnimationLabel.transform = CGAffineTransform.identity
        }) { [weak self] _ in
            guard let this = self else { return }
            this.placeholderAnimationLabel.alpha = 0.0
            if let completion = completion {
                completion()
            }
        }
    }

    /// Whether the floating label is in the active or inactive state.
    var active: Bool = false {
        didSet {
            floatingLabel.textColor = active ? .lightGray : .gray
            placeholderAnimationLabel.textColor = .lightGray
        }
    }

}
