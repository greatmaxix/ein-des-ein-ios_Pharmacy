//
//  TextInputView.swift
//  TestProject
//
//  Created by CGI-Kite on 16.06.2020.
//  Copyright © 2020 CGI-Kite. All rights reserved.
//

import UIKit

final class TextInputView: UIView {
    
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
                return .numberPad
            default:
                return .default
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
                return R.image.validationClose()
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
    }
    
    // MARK: - Properties

    private var backgroundView: UIView!
    private var inputStatusImageView: UIImageView!
    private var inputTextField: UITextField!
    private var errorLabel: UILabel!
    
    private var lcBackgroundViewHeight: NSLayoutConstraint!
    private var textFieldDelegate: UITextFieldDelegate? {
        
        willSet {
            inputTextField.delegate = newValue
        }
    }
    
    var contentType: ContentStyle = .other {
        
        willSet {
            inputTextField.placeholder = newValue.placeHolder
            inputTextField.keyboardType = newValue.keyboardType
        }
    }
    
    var visualStyle: VisualStyle = .standart {
        
        willSet {
            backgroundView.layer.borderColor = newValue.borderColor
            inputStatusImageView.image = newValue.image
            inputTextField.textColor = newValue.textColor
        }
    }
    
    var backgroundViewHeight: CGFloat = Const.backgroundViewHeight {
        
        willSet {
            lcBackgroundViewHeight.constant = newValue
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
    
    // MARK: - Setup
    
    private func setup() {
        
        backgroundView = UIView()
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.layer.cornerRadius = 5
        backgroundView.layer.borderWidth = 1
        addSubview(backgroundView)
        
        inputStatusImageView = UIImageView()
        backgroundView.addSubview(inputStatusImageView)
        inputStatusImageView.translatesAutoresizingMaskIntoConstraints = false
        
        errorLabel = UILabel()
        addSubview(errorLabel)
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        inputTextField = UITextField()
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(inputTextField)
        
        lcBackgroundViewHeight = backgroundView.heightAnchor.constraint(equalToConstant: Const.backgroundViewHeight)
        
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            lcBackgroundViewHeight,
            backgroundView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 0),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            backgroundView.bottomAnchor.constraint(lessThanOrEqualTo: errorLabel.topAnchor, constant: Const.lbErrorTop)
        ])
        
        NSLayoutConstraint.activate([
            errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Const.lbErrorLeft),
            errorLabel.trailingAnchor.constraint(equalTo: inputStatusImageView.leadingAnchor, constant: 0),
            errorLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            errorLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: min(Const.lbErrorMinHeight, frame.height))
        ])

        NSLayoutConstraint.activate([
            inputStatusImageView.widthAnchor.constraint(equalTo: backgroundView.heightAnchor,
                                                        multiplier: Const.ivMultiplier, constant: -Const.ivHeightOffset),
            inputStatusImageView.heightAnchor.constraint(equalTo: inputStatusImageView.widthAnchor, multiplier: 1),
            inputStatusImageView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: Const.ivTralling),
            inputStatusImageView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            inputTextField.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: Const.textfieldLeading),
            inputTextField.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: Const.textfieldSpace),
            inputTextField.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -Const.textfieldSpace),
            inputTextField.trailingAnchor.constraint(equalTo: inputStatusImageView.leadingAnchor, constant: -Const.textfieldSpace)
        ])
        visualStyle = .standart
    }
    
    private func setupFonts() {
        inputTextField.font = R.font.sourceSansProRegular(size: Const.defaultFontSize)
        errorLabel.font = R.font.sourceSansProRegular(size: Const.errorFontSize)
        errorLabel.textColor = R.color.validationRed()
    }
}

// MARK: - TextInputView + Constants

fileprivate extension TextInputView {
    
    private struct Const {
        
        private init() {}
        
        static let backgroundViewHeight: CGFloat = 48
        static let lbErrorTop: CGFloat = -8
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
