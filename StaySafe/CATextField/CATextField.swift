//  Copyright © 2019 iProgram. All rights reserved.

import UIKit

class CATextField: UITextField {

    // MARK: Constants

    private struct Constants {
        static let underlineTopMargin: CGFloat = 4
    }

    // MARK: References to the related views

    @objc private var underline: CATextFieldUnderline?
    private var validationLabel: CATextFieldValidationLabel?
    var floatingLabel: CATextFieldFloatingLabel?

    /// Replace the built in validation label with another one.
    /// Typically, you would do this if the normal position of the validation label is not what you want,
    /// and you want to use another one you have positioned in a Storyboard/Nib.
    ///
    /// In the scenario where there are multiple labels which overlap each other
    /// (e.g. if you have textfields side-by-side)
    /// it's recommended that the view controller handle the special case.
    /// You can KVO on the `valid` property and set the `validationLabelHidden` accordingly.
    func associateWithValidationLabel(_ validationLabel: CATextFieldValidationLabel) {
        self.validationLabel = validationLabel
        validationLabel.textField = self
    }

    // MARK: Placeholder

    @IBInspectable override var placeholder: String? {
        didSet {
            floatingLabel?.text = placeholder
            if placeholder != oldValue {
                applyPlaceholderStyling()
            }
        }
    }

    private func applyPlaceholderStyling() {
        guard let placeholder = placeholder else { return }
//        let attr: [String: AnyObject] = [NSFontAttributeName: font!, NSForegroundColorAttributeName: styleDefinition.placeholderTextColor]
//        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: attr)
    }

    /// Stores the text of the placeholder when it's hidden, so it can be restored
    private var hiddenPlaceholder: String?

    /// Shows and hides the placeholder without affecting the placeholder text which was set, nor the text on the floating label.
    /// Used in conjunction with the floating label, whereby the real placeholder is hidden when the floating label is shown.
    /// Has no effect when reduce motion is on.
    private var placeholderHidden = false {
        didSet {
            guard placeholderHidden != oldValue else { return }
            if placeholderHidden {
                hiddenPlaceholder = placeholder
                super.placeholder = nil  // dont trigger the didSet
            } else {
                super.placeholder = hiddenPlaceholder  // dont trigger the didSet
                applyPlaceholderStyling()  // so manually apply the style
            }
        }
    }

    // MARK: Other Properties

//    var floatingLabelAccessibilityLabel: String? {
//        didSet { floatingLabel?.floatingLabelAccessibilityLabel = floatingLabelAccessibilityLabel }
//    }

    /// A Boolean value that determines whether the underline is hidden.
    @IBInspectable var underlineHidden: Bool = false {
        didSet {
            underline?.isHidden = underlineHidden
        }
    }

    /// A Boolean value that determines whether the validation label is hidden.
    @IBInspectable var validationLabelHidden: Bool = false {
        didSet {
            validationLabel?.isHidden = validationLabelHidden
        }
    }

    /// The validation message currently displayed
    var validationText: String? {
        return validationLabel?.text
    }

    override var isHidden: Bool {
        didSet {
            underlineHidden = isHidden
            validationLabelHidden = isHidden
            floatingLabel?.hidden = isHidden
        }
    }

    /// Whether to format the text while the user is typing.
    /// When true, and `shouldChangeCharactersInRange` is true, it will replace the text with the result of the formatter's `formatTextForDisplay` method.
    @IBInspectable var formatTextWhileTyping: Bool = false

    // MARK: Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        setupNotifications()
        contentVerticalAlignment = .center
//        styleDefinition = CATextField.textFieldStyles[CATextField.defaultStyle]
        applyPlaceholderStyling()
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if superview != nil {
            // added to superview
            if underline == nil && !underlineHidden {
                underline = CATextFieldUnderline(textField: self)
            }
            if validationLabel == nil {
                validationLabel = CATextFieldValidationLabel(textField: self)
            }
            if floatingLabel == nil {
                floatingLabel = CATextFieldFloatingLabel(textField: self)
            }
        } else {
            // removed from superview
            underline?.removeFromSuperview()
            validationLabel?.removeFromSuperview()
            floatingLabel?.removeFromSuperview()
        }
    }

    // MARK: Notification related methods

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: .didBeginEditing, name: UITextField.textDidBeginEditingNotification, object: self)
        NotificationCenter.default.addObserver(self, selector: .didEndEditing, name: UITextField.textDidEndEditingNotification, object: self)
    }

    @objc func didBeginEditing(_ notification: Notification) {
        if let formatter = validatorFormatter as? ValidatorFormatterTextFieldDelegate {
            formatter.replaceWithOriginalText(self)
        }

        underline?.highlighted = true
        floatingLabel?.active = true

        placeholderHidden = true
        floatingLabel?.showFloatingLabel()
    }

    @objc func didEndEditing(_ notification: Notification) {
        if let formatter = validatorFormatter as? ValidatorFormatterTextFieldDelegate {
            formatter.formatTextInTextField(self)
        }

        underline?.highlighted = false
        floatingLabel?.active = false
        if text.isNilOrEmpty {
            floatingLabel?.hideFloatingLabel { [weak self] in
                self?.placeholderHidden = false
            }
        } else {
            // there is text, so the real placeholder doesnt appear visually. Just reset the state.
            placeholderHidden = false
        }
        let _ = try? validate(true)
    }

    // MARK: Validation

    // allows a second delegate to be called after the first
    private weak var chainedDelegate: UITextFieldDelegate?

    /// Validation rule for the text field as a `String`. This is the raw value of the `ValidationRule` enum, for use in storyboard/nib.
    @IBInspectable var validationRuleKey: String? {
        didSet {
            if let ruleKey = validationRuleKey {
                validationRule = try! ValidationRulesRegistry.ruleFromRawValue(ruleKey) // swiftlint:disable:this force_try
            } else {
                validationRule = nil
            }
        }
    }

    /// Validation rule for the text field.
    var validationRule: ValidationRule? {
        didSet {
            validatorFormatter = validationRule?.validatorFormatter
        }
    }

    /// The `ValidatorFormatter` which applies the validation and formatting logic for the `ValidationRule`.
    var validatorFormatter: ValidatorFormatter? {
        didSet {
            delegate = validatorFormatter
            validatorFormatter?.originalText = text  // situation where text is already set at the time the validator is assigned
        }
    }

    /// The `delegate` property of `CBATextField` is aware of the `ValidatorFormatterTextFieldDelegate`,
    /// ensuring that any other `UITextFieldDelegate` which is set will be chained to the validatorFormatter,
    /// regardless of the ordering of when the properties are set.
    override var delegate: UITextFieldDelegate? {
        get { return super.delegate }
        set {
            // when setting to nil
            guard newValue != nil else {
                super.delegate = nil
                return
            }

            // new value is a validatorFormatter
            if let validatorFormatter = newValue as? ValidatorFormatter {
                validatorFormatter.chainedDelegate = chainedDelegate
                super.delegate = newValue

                // new value is NOT a validatorFormatter
            } else {
                chainedDelegate = newValue
                validatorFormatter?.chainedDelegate = newValue

                // only update delegate if it's nil, or if it's not a validatorFormatter
                if delegate == nil || !(delegate is ValidatorFormatter) {
                    super.delegate = newValue
                }
            }
        }
    }

    /// The text displayed by the text field. This subclass adds a property observer to keep validatorFormatter.originalText up to date,
    /// and to make the underline look valid if the text is valid.
    /// The floating label will be immediately shown if the text is not nil or empty.
    override var text: String? {
        didSet {
            if !text.isNilOrEmpty {
                floatingLabel?.showFloatingLabel()
            }
            guard let validatorFormatter = validatorFormatter else { return }
            validatorFormatter.originalText = text
            let _ = try? validate()
        }
    }

    /**
     The text which corresponds to the value in the model.

     For the getter, this returns the text in a format that can be used for the model.
     It returns nil if the original text entered by the user is invalid, or if no validation rule has been set.

     For the setter, if the new value is valid, the `text` property will be updated with the formatted text.
     It is also stored as if it was something the user typed in.
     If the new value is invalid, this is essentially a no-op.

     Note that a get after a set may not return the same value.
     */
    var textForModel: String? {
        get {
            guard let validatorFormatter = validatorFormatter, let _ = try? validate() else { return nil }
            return validatorFormatter.formatter.formatTextForModel(validatorFormatter.originalText)
        }
        set {
            guard let validatorFormatter = validatorFormatter, validatorFormatter.validator.isValid(newValue) else { return }
            text = validatorFormatter.formatter.formatTextForDisplay(newValue)  // property observer for text replaces originalText...
            if !formatTextWhileTyping {
                // so replace it afterwards. But not when formatTextWhileTyping, that originalValue matches the formatted one.
                validatorFormatter.originalText = newValue
            }
        }
    }

    /**
     Validates the original text that was successfully entered by the user, throwing an error if it is invalid.
     When no validation rule has been set, validation will pass.

     By default, `showError` is false, and the UI does not indicate when validation fails.
     If `showError` is true, then the UI will be updated to indicate validation failure.
     Note that the UI will always be updated to indicate when a validation passes, regardless of the value of `showError`.
     */
    func validate(_ showError: Bool = false) throws {
        guard let validatorFormatter = validatorFormatter else { return }
        do {
            try validatorFormatter.validator.validate(validatorFormatter.originalText)
            moveToValidatedState()
        } catch let error {
            if showError {
                showValidationError(error as? ValidationError)
            }
            valid = false
            throw error
        }
    }

    /**
     Shows the given validation message, marking the text field as invalid
     */
    func showValidationError(_ error: ValidationError?) {
        underline?.valid = false

        if let error = error {
            validationLabel?.showError(error.message)

            // accessibility is permanently replaced with the validation error
            accessibilityLabel = error.message
        }

        valid = false
    }

    // TODO: Foundations - the worst name ever
    /// Returns whether the textfield is valid as a Bool. This is just a wrapper around `validate:`.
    func isValid(_ showError: Bool = false) -> Bool {
        do {
            try validate(showError)
            return true
        } catch {
            return false
        }
    }

    /**
     Re-set's the textfield to be in valid state - visually.
     */
    func moveToValidatedState(_ animated: Bool = true) {
        underline?.valid = true
        validationLabel?.hideError(animated)
        valid = true
    }

    /**
     Whether the textfield was valid in the most recent `validate:` call.
     This property can be observed using KVO.
     */
    dynamic private(set) var valid: Bool = true
}

private extension Selector {
    static let didBeginEditing = #selector(CATextField.didBeginEditing(_:))
    static let didEndEditing = #selector(CATextField.didEndEditing(_:))
}
