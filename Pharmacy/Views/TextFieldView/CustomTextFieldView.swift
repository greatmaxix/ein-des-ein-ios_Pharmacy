//
//  CustomTextFieldView.swift
//  Pharmacy
//
//  Created by Anna Yatsun on 03.03.2021.
//  Copyright © 2021 pharmacy. All rights reserved.
//

import UIKit

enum TextFieldEvent {
    case clear
}

class CustomTextFieldView: UIView, NibView {
    
    @IBOutlet var textField: UITextField!
    
    var eventHandel: ((TextFieldEvent) -> ())?
  
    @IBOutlet var clearButton: UIButton!
    
    @IBAction func clearButtonAction(_ sender: Any) {
        self.textField.text = nil
        self.clearButton.isHidden = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        setup()
        isButtonHidden()
    }
    
    // MARK: - Init / Deinit Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadViewFromNib()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        loadViewFromNib()
        setup()
    }
    
    func configure(placeholder: String) {
        self.textField.placeholder = placeholder
    }
    
    private func setup() {
        textField.delegate = self
        layer.borderWidth = 1
        layer.borderColor = UIColor(red: 0.859, green: 0.882, blue: 0.922, alpha: 1).cgColor
        layer.cornerRadius = 12
    }
    
    private func isButtonHidden() {
        if textField.text!.count == 0 {
            clearButton.isHidden = true
            
        } else {
            clearButton.isHidden = false
        }
    }
}

extension CustomTextFieldView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if (textField.text?.count ?? 0) >= 0 {
            clearButton.isHidden = false
        }  else {
            clearButton.isHidden = true
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText:String = textField.text ?? ""
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        if updatedText.isEmpty {
            clearButton.isHidden = true

            textField.textColor = UIColor.lightGray
            
            textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.beginningOfDocument)
        }
         else if textField.textColor == UIColor.lightGray && !string.isEmpty {
            textField.textColor = UIColor.black
            clearButton.isHidden = false
            textField.text = string
        }

        else {
            clearButton.isHidden = false
            return true
        }
        clearButton.isHidden = true
        return false
        }
    
    func  textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let color = UIColor(red: 0.145, green: 0.4, blue: 0.976, alpha: 1).cgColor
        self.layer.borderColor = color

        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let color = UIColor(red: 0.859, green: 0.882, blue: 0.922, alpha: 1).cgColor
        self.layer.borderColor = color
    }
    
}

