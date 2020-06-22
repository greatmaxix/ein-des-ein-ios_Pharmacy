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
    private var textFields: [UITextField]!
    private var circleViews: [UIView]!
    
    var textFieldsCount: Int = 6
    var textFieldWidth: CGFloat = 20
    var circleColor: UIColor? = R.color.confirmCircleGray()
    weak var delegate: ConfirmCodeDelegate?
    
    var code: String {
        
        var result: String = ""
        textFields.forEach({result += ($0.text ?? "")})
        result.removeAll(where: {$0 == Const.separator})
        return result
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
    
    func startInput() {
        
        textFields[0].isUserInteractionEnabled = true
        textFields[0].becomeFirstResponder()
        circleViews[0].isHidden = true
    }
    
    func setConfirmationCode(code: String) {
        
        let validator: SMSCodeValidator = SMSCodeValidator()
        if validator.validate(text: code) == true, code.count == textFields.count {
            
            var confirmCode = code
            textFields.forEach({
                $0.text = String(confirmCode.removeFirst())
                $0.isUserInteractionEnabled = false
            })
            circleViews.forEach({ $0.isHidden = true })
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
        
        textFields = []
        circleViews = []
        
        // swiftlint:disable identifier_name
        for i in 0..<textFieldsCount {
            
            let field: UITextField = UITextField()
            field.keyboardType = .numberPad
            field.tintColor = R.color.textDarkGray()
            field.textColor = R.color.textDarkGray()
            field.textAlignment = .center
            field.isUserInteractionEnabled = false
            
            field.tag = i
            field.font = UIFont.systemFont(ofSize: 24, weight: .bold)
            field.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
            textFields.append(field)
            
            let circle: UIView = UIView()
            circle.backgroundColor = circleColor
            circle.translatesAutoresizingMaskIntoConstraints = false
            circle.layer.cornerRadius = circleRadius
            circle.isHidden = false
            circleViews.append(circle)
            field.addSubview(circle)

            NSLayoutConstraint.activate([
                circle.centerYAnchor.constraint(equalTo: field.centerYAnchor),
                circle.centerXAnchor.constraint(equalTo: field.centerXAnchor),
                circle.heightAnchor.constraint(equalTo: field.heightAnchor, multiplier: Const.circleMultiplier),
                circle.widthAnchor.constraint(equalTo: circle.heightAnchor)
            ])
            
            fieldsStack.addArrangedSubview(field)
        }
        
        let spacesCount: CGFloat = CGFloat(textFieldsCount + 1)
        let fieldsWidth: CGFloat = textFieldWidth * CGFloat(textFieldsCount)
        
        fieldsStack.spacing = (frame.width - fieldsWidth - 2 * Const.stackSpace) / spacesCount
        fieldsStack.distribution = .fillEqually
        // swiftlint:enable identifier_name
    }
    
    @objc private func editingChanged(_ sender: UITextField) {
        
        if let text: String = sender.text, let character: Character = text.last, character != Const.separator {
            
            if text.count > Const.maxCountForOtherFields, sender.tag > 0 {
                sender.text = String(text.dropLast(text.count - Const.maxCountForOtherFields))
            } else if sender.tag == 0, text.count > Const.maxCountForFirstField {
                
                sender.text = String(text.dropLast(text.count - Const.maxCountForFirstField))
            }
                          
            if sender.tag+1 < textFields.count {
                 
                sender.isUserInteractionEnabled = false
                sender.resignFirstResponder()
                
                textFields[sender.tag + 1].isUserInteractionEnabled = true
                textFields[sender.tag + 1].becomeFirstResponder()
                textFields[sender.tag + 1].text = String(Const.separator)
                circleViews[sender.tag + 1].isHidden = true
            } else {
                
                delegate?.lastDigitWasInputed(code: code)
            }
        }
        if sender.tag - 1 >= 0, sender.text == "" {
            
            sender.isUserInteractionEnabled = false
            textFields[sender.tag - 1].isUserInteractionEnabled = true
            sender.resignFirstResponder()
            textFields[sender.tag - 1].becomeFirstResponder()
            circleViews[sender.tag].isHidden = false
        }
    }
}

// MARK: - Constants

fileprivate extension ConfirmCodeView {
    
    struct Const {
        static let maxCountForFirstField: Int = 1
        static let maxCountForOtherFields: Int = 2
        static let circleMultiplier: CGFloat = 0.35
        static let stackSpace: CGFloat = 12
        static let separator: Character = " "
    }
}
