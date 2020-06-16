//
//  TextInputView.swift
//  TestProject
//
//  Created by CGI-Kite on 16.06.2020.
//  Copyright © 2020 CGI-Kite. All rights reserved.
//

import UIKit

// swiftlint:disable all

final class TextInputView: UIView {
    
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

    var backgroundView: UIView!
    var inputStatusImageView: UIImageView!
    var inputTextField: UITextField!
    var errorLabel: UILabel!
    var contentType: ContentStyle = .other {
        
        willSet {
            inputTextField.placeholder = newValue.placeHolder
        }
    }
    var visualStyle: VisualStyle = .standart {
        
        willSet {
            backgroundView.layer.borderColor = newValue.borderColor
            inputStatusImageView.image = newValue.image
            inputTextField.textColor = newValue.textColor
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
        
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            backgroundView.heightAnchor.constraint(equalToConstant: 48),
            backgroundView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 0),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            backgroundView.bottomAnchor.constraint(lessThanOrEqualTo: errorLabel.topAnchor, constant: -8)
        ])
        
        NSLayoutConstraint.activate([
            errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            errorLabel.trailingAnchor.constraint(equalTo: inputStatusImageView.leadingAnchor, constant: 0),
            errorLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            errorLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: min(15, frame.height))
        ])

        NSLayoutConstraint.activate([
            inputStatusImageView.widthAnchor.constraint(equalTo: backgroundView.heightAnchor, multiplier: 0.8, constant: -10),
            inputStatusImageView.heightAnchor.constraint(equalTo: inputStatusImageView.widthAnchor, multiplier: 1),
            inputStatusImageView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -14),
            inputStatusImageView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            inputTextField.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
            inputTextField.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 5),
            inputTextField.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -5),
            inputTextField.trailingAnchor.constraint(equalTo: inputStatusImageView.leadingAnchor, constant: -5)
        ])
        visualStyle = .standart
    }
    
    private func setupFonts() {
        inputTextField.font = R.font.sourceSansProRegular(size: 16)
        errorLabel.font = R.font.sourceSansProRegular(size: 12)
        errorLabel.textColor = R.color.validationRed()
    }
}
