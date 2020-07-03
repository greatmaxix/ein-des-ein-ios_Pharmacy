//
//  ConfirmCodeView.swift
//  Pharmacy
//
//  Created by CGI-Kite on 19.06.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

protocol ConfirmCodeDelegate: class {
    
    func lastDigitWasInputed(code: String)
}

final class ConfirmCodeView: UIView {
    
    private var fieldsStack: UIStackView!
    private var stackTopConstraint: NSLayoutConstraint!
    private var stackBottomConstraint: NSLayoutConstraint!
    private var codeLabels: [UILabel]!
    private var inputTextField: UITextField!
    private var tapGesture: UITapGestureRecognizer!
    
    var textFieldsCount: Int = 5
    var textFieldWidth: CGFloat = 40
    var circleColor: UIColor? = R.color.confirmCircleGray()
    weak var delegate: ConfirmCodeDelegate?
    
    var code: String {
        
        return inputTextField.text ?? ""
    }
    
    private var circleRadius: CGFloat {
        
        return (bounds.height - stackTopConstraint.constant + stackBottomConstraint.constant) * Const.circleMultiplier / 2
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    @objc func startInput() {
        
        inputTextField.isUserInteractionEnabled = true
        inputTextField.becomeFirstResponder()
    }
    
    func setConfirmationCode(code: String) {
        
        let validator: SMSCodeValidator = SMSCodeValidator()
        if validator.validate(text: code) == true, code.count == codeLabels.count {
            
            var confirmCode = code
            codeLabels.forEach({
                $0.text = String(confirmCode.removeFirst())
                $0.isUserInteractionEnabled = false
            })
        }
    }
    
    // MARK: - Setup
    
    private func setup() {
        
        fieldsStack = UIStackView()
        fieldsStack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(fieldsStack)
        
        stackTopConstraint = fieldsStack.topAnchor.constraint(equalTo: topAnchor)
        stackBottomConstraint = fieldsStack.bottomAnchor.constraint(equalTo: bottomAnchor)

        NSLayoutConstraint.activate([
            fieldsStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Const.stackSpace),
            fieldsStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Const.stackSpace),
            stackTopConstraint,
            stackBottomConstraint
        ])
        
        setupTextFields()
    }
    
    private func setupTextFields() {
        
        codeLabels = []
        
        inputTextField = UITextField()
        inputTextField.keyboardType = .numberPad
        inputTextField.textContentType = .oneTimeCode
        inputTextField.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
        addSubview(inputTextField)
        
        // swiftlint:disable identifier_name
        for i in 0..<textFieldsCount {
            
            let label: UILabel = UILabel()
            label.tintColor = .clear
            label.textColor = R.color.textDarkBlue()
            label.textAlignment = .center
            label.isUserInteractionEnabled = false
            label.backgroundColor = R.color.confirmLightGray()
            label.layer.borderWidth = 1
            label.layer.cornerRadius = 10
            label.layer.borderColor = R.color.backgroundGray()?.cgColor
            
            label.clipsToBounds = true
            label.tag = i
            label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
            codeLabels.append(label)
            
            fieldsStack.addArrangedSubview(label)
        }
        
        let spacesCount: CGFloat = CGFloat(textFieldsCount + 1)
        let fieldsWidth: CGFloat = textFieldWidth * CGFloat(textFieldsCount)
        
        fieldsStack.spacing = (frame.width - fieldsWidth) / (spacesCount - 1)
        fieldsStack.distribution = .fillEqually
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(startInput))
        addGestureRecognizer(tapGesture)
        // swiftlint:enable identifier_name
    }
    
    @objc private func editingChanged(_ sender: UITextField) {
        
        if let text: String = sender.text {
            var index: Int = 0
            var resultText: String = ""
            
            codeLabels.forEach({$0.text = nil})
            
            for ch in text where index < textFieldsCount {
                
                resultText.append(ch)
                codeLabels[index].text = String(ch)
                index += 1
            }
            sender.text = resultText
            
            if resultText.count == textFieldsCount {
                
                delegate?.lastDigitWasInputed(code: resultText)
            }
        }
    }
    
    func clear() {
        inputTextField.text = nil
        codeLabels.forEach({$0.text = nil})
    }
}

// MARK: - Constants

fileprivate extension ConfirmCodeView {
    
    struct Const {
        static let maxCountForFirstField: Int = 1
        static let maxCountForOtherFields: Int = 2
        static let circleMultiplier: CGFloat = 0.35
        static let stackSpace: CGFloat = 16
        static let separator: Character = " "
    }
}
