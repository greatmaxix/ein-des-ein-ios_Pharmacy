//
//  CreateOrderContactInfoCell.swift
//  Pharmacy
//
//  Created by Mikhail Timoscenko on 29.10.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

class CreateOrderContactInfoCell: UITableViewCell {

    @IBOutlet weak var nameTextView: TextInputView!
    @IBOutlet weak var phoneTextView: TextInputView!
    @IBOutlet weak var emailTextView: TextInputView!

    private var contactInfo: OrderContactInfo?

    func apply(contact: OrderContactInfo) {
        self.contactInfo = contact

        nameTextView.contentType = .name
        nameTextView.placeholder = "Имя"
        nameTextView.text = contact.name

        phoneTextView.contentType = .phone
        phoneTextView.placeholder = ""
        phoneTextView.text = contact.phone

        emailTextView.contentType = .email
        emailTextView.placeholder = "Почта"
        emailTextView.text = contact.email

        nameTextView.textFieldDelegate = self
        emailTextView.textFieldDelegate = self
        phoneTextView.textFieldDelegate = self
    }

}

extension CreateOrderContactInfoCell: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if let text = textField.text, let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)

            if nameTextView.containsObject(textfield: textField) == true {
                contactInfo?.name = updatedText
            }
            if phoneTextView.containsObject(textfield: textField) == true {
                contactInfo?.phone = updatedText
            }
            if emailTextView.containsObject(textfield: textField) == true {
                contactInfo?.email = updatedText
            }
        }

        return true
    }

}
