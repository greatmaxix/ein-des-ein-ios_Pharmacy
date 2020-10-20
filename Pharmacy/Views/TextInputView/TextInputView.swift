//
//  TextInputView.swift
//  TestProject
//
//  Created by CGI-Kite on 16.06.2020.
//  Copyright © 2020 CGI-Kite. All rights reserved.
//

import UIKit

final class TextInputView: UIView {
    // MARK: - Properties

    private var backgroundView: UIView!
    private var inputStatusButton: UIButton!
    private var inputTextField: UITextField!
    private var errorLabel: UILabel!
    private var constraintBackgroundViewHeight: NSLayoutConstraint!
    
    private let formatter = PhoneFormatter()
    
    var textFieldDelegate: UITextFieldDelegate? {
        
        willSet {
            inputTextField.delegate = newValue
        }
    }
    
    var contentType: ContentStyle = .other {
        
        willSet {
            errorLabel.text = nil
            inputTextField.placeholder = newValue.placeHolder
            setupPlaceHolder()
            inputTextField.keyboardType = newValue.keyboardType
            inputTextField.text = newValue.startText
        }
    }
    
    var visualStyle: VisualStyle = .standart {
        
        willSet {
            backgroundView.layer.borderColor = newValue.borderColor
            backgroundView.backgroundColor = newValue.backgroundColor
            inputStatusButton.setBackgroundImage(newValue.image, for: .normal)
            inputTextField.textColor = newValue.textColor
            errorLabel.isHidden = newValue != .unsuccessfulValidation
        }
    }
    
    var backgroundViewHeight: CGFloat = Const.backgroundViewHeight {
        
        willSet {
            constraintBackgroundViewHeight.constant = newValue
        }
    }
    
    var text: String? {
        get {
            inputTextField.text
        }
        set {
            inputTextField.text = newValue
        }
    }
    var returnKeyType: UIReturnKeyType = .default {
        
        willSet {
            inputTextField.returnKeyType = newValue
        }
    }
    
    var placeholder: String? {
        get {
            return inputTextField.placeholder
        }
        set {
            inputTextField.placeholder = newValue ?? contentType.placeHolder
        }
    }
    
    var needsCountryCode: Bool = true
    
    override var tag: Int {
        
        didSet {
            inputTextField.tag = tag
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
        setupFonts()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
        setupFonts()
    }
    
    // MARK: - Actions
    
    func startEditing() {
        inputTextField.becomeFirstResponder()
    }
    
    @objc private func editingChanged(sender: UITextField) {
        
        if visualStyle != .editing {
            visualStyle = .editing
        }
        
        if contentType == .phone {
            sender.text = formatter.formattedNumber(number: sender.text ?? "", needsCountryCode: needsCountryCode)
        }
    }
    
    @objc private func editingDidEnd(sender: UITextField) {
        
        validate()
    }
    
    @objc private func clearText() {
        
        if visualStyle == .editing {
            inputTextField.text = ""
        }
    }
    
    @discardableResult
    func validate() -> Bool {
        var result = true
        let searchDebouncer: Executor = .debounce(interval: 1.0)
        searchDebouncer.execute {[weak self] in
            if let validator: BaseTextValidator = self?.contentType.validator {
                
                let res: Bool = validator.validate(text: self?.inputTextField.text)
                self?.visualStyle = res ? .successfulValidation : .unsuccessfulValidation
                self?.errorLabel.text = res ? "" : validator.errorText
                result = res
            }
        }
        return result
    }
    
    // MARK: - Setup
    
    private func setup() {
        self.backgroundColor = .clear

        setupBackgroundView()
        setupInputStatusButton()
        setupErrorLabel()
        setupInputTextField()

        visualStyle = .standart
    }
    
    private func setupBackgroundView() {
        backgroundView = UIView()
        backgroundView.backgroundColor = .white
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.layer.cornerRadius = Const.backgroundViewHeight / 2
        backgroundView.layer.borderWidth = 1
        addSubview(backgroundView)
        
        constraintBackgroundViewHeight = backgroundView
            .heightAnchor
            .constraint(equalToConstant: Const.backgroundViewHeight)
        
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            constraintBackgroundViewHeight,
            backgroundView.topAnchor.constraint(equalTo: backgroundView.topAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    private func setupErrorLabel() {
        errorLabel = UILabel()
        addSubview(errorLabel)
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Const.lbErrorLeft),
            errorLabel.trailingAnchor.constraint(equalTo: inputStatusButton.leadingAnchor),
            errorLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            errorLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: min(Const.lbErrorMinHeight, frame.height)),
            backgroundView.bottomAnchor.constraint(lessThanOrEqualTo: errorLabel.topAnchor,
                                                   constant: Const.lbErrorTop)
        ])
    }
    
    private func setupInputStatusButton() {
        inputStatusButton = UIButton()
        inputStatusButton.addTarget(self, action: #selector(clearText), for: .touchUpInside)
        backgroundView.addSubview(inputStatusButton)
        inputStatusButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            inputStatusButton.widthAnchor.constraint(equalTo: backgroundView.heightAnchor,
                                                        multiplier: Const.ivMultiplier, constant: -Const.ivHeightOffset),
            inputStatusButton.heightAnchor.constraint(equalTo: inputStatusButton.widthAnchor, multiplier: 1),
            inputStatusButton.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: Const.ivTralling),
            inputStatusButton.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor, constant: 0)
        ])
    }
    
    private func setupInputTextField() {
        inputTextField = UITextField()
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(inputTextField)
        inputTextField.tag = tag
        inputTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        inputTextField.addTarget(self, action: #selector(editingDidEnd), for: .editingDidEnd)
        
        NSLayoutConstraint.activate([
            inputTextField.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor,
                                                    constant: Const.textfieldLeading),
            inputTextField.topAnchor.constraint(equalTo: backgroundView.topAnchor,
                                                constant: Const.textfieldSpace),
            inputTextField.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor,
                                                   constant: -Const.textfieldSpace),
            inputTextField.trailingAnchor.constraint(equalTo: inputStatusButton.leadingAnchor,
                                                     constant: -Const.textfieldSpace)
        ])
    }
    
    private func setupFonts() {
        inputTextField.font = R.font.openSansRegular(size: Const.defaultFontSize)
        errorLabel.font = R.font.openSansRegular(size: Const.errorFontSize)
        errorLabel.textColor = R.color.validationRed()
    }
    
    private func setupPlaceHolder() {
        
        if let text = inputTextField!.attributedPlaceholder, contentType != .email {
            
            let attrText = NSMutableAttributedString(attributedString: text)
            let asterisk: NSAttributedString = NSAttributedString(string: "*", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red,
                    NSAttributedString.Key.font: R.font.openSansRegular(size: 16) ?? UIFont.systemFont(ofSize: 16)])
            attrText.append(asterisk)
            inputTextField!.attributedPlaceholder = attrText
        }
    }
}

// MARK: - TextInputView + Constants

fileprivate extension TextInputView {
    
    struct Const {
        
        private init() {}
        
        static let backgroundViewHeight: CGFloat = 48
        static let lbErrorTop: CGFloat = 0
        static let lbErrorLeft: CGFloat = 5
        static let textfieldSpace: CGFloat = 5
        static let textfieldLeading: CGFloat = 16
        static let ivTralling: CGFloat = -14
        static let ivHeightOffset: CGFloat = 10
        static let ivMultiplier: CGFloat = 0.8
        static let lbErrorMinHeight: CGFloat = 15
        
        static let defaultFontSize: CGFloat = 16
        static let errorFontSize: CGFloat = 12
    }
}

// MARK: - External declarations
extension TextInputView {
    // MARK: - Enums
    
    enum ContentStyle {
        
        case email
        case phone
        case name
        case other
        
        var placeHolder: String? {
            
            switch self {
            case .email:
                return R.string.localize.placeholderEmail()
            case .phone:
                return R.string.localize.placeholderPhone()
            case .name:
                return R.string.localize.placeholderName()
            default:
                return nil
            }
        }
        
        var keyboardType: UIKeyboardType {
            
            switch self {
            case .email:
                return .emailAddress
            case .name:
                return .default
            case .phone:
                return .phonePad
            default:
                return .default
             }
        }
        
        var validator: BaseTextValidator? {
            
            switch self {
            case .email:
                return EmailValidator()
            case .name:
                return NameValidator()
            case .phone:
                return PhoneValidator()
            default:
                return nil
            }
        }
        
        var startText: String? {
            switch self {
            case .email, .name, .other:
                return nil
            case .phone:
                return nil

            }
        }
    }

    enum VisualStyle {
        
        case standart
        case editing
        case successfulValidation
        case unsuccessfulValidation
        
        var borderColor: CGColor? {
            
            switch self {
            case .standart:
                return R.color.validationGray()?.cgColor
            case .editing:
                return R.color.validationBlue()?.cgColor
            case .successfulValidation:
                return R.color.validationGreen()?.cgColor
            case .unsuccessfulValidation:
                return R.color.validationRed()?.cgColor
            }
        }

        var image: UIImage? {
            
            switch self {
            case .standart:
                return nil
            case .editing:
                return R.image.cancelSearch()
            case .successfulValidation:
                return R.image.validationSuccess()
            case .unsuccessfulValidation:
                return R.image.validationError()
            }
        }
        
        var textColor: UIColor? {
            
            switch self {
            case .unsuccessfulValidation:
                return R.color.validationRed()
            case .editing:
                return R.color.textDarkBlue()
            case .standart, .successfulValidation:
                return R.color.textDarkGray()
            }
        }
        
        var backgroundColor: UIColor? {
            switch self {
            case .editing, .successfulValidation, .unsuccessfulValidation:
                return .clear
            case .standart:
                return R.color.backgroundGray()
            }
        }
    }
}
