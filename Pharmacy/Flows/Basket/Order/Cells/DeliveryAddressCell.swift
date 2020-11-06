//
//  DeliveryAddressCell.swift
//  Pharmacy
//
//  Created by Mikhail Timoscenko on 30.10.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

class DeliveryAddressCell: UITableViewCell {

    @IBOutlet weak var cityTextView: TextInputView!
    @IBOutlet weak var streetTextView: TextInputView!
    @IBOutlet weak var houseTextView: TextInputView!
    @IBOutlet weak var appartmentTextView: TextInputView!

    private var delivery: OrderDeliveryAddress?

    func apply(delivery: OrderDeliveryAddress) {
        self.delivery = delivery

        cityTextView.contentType = .city
        cityTextView.placeholder = "Город"
        cityTextView.text = delivery.city

        streetTextView.contentType = .street
        streetTextView.placeholder = "Улица"
        streetTextView.text = delivery.street

        houseTextView.contentType = .house
        houseTextView.placeholder = "№ Дома"
        houseTextView.text = delivery.house

        appartmentTextView.placeholder = "№ Квартиры"
        appartmentTextView.text = delivery.appartment
        appartmentTextView.statusButtonDisable()
        appartmentTextView.setupKeyboardType(type: .numberPad)

        cityTextView.textFieldDelegate = self
        streetTextView.textFieldDelegate = self
        houseTextView.textFieldDelegate = self
        appartmentTextView.textFieldDelegate = self
    }

}

extension DeliveryAddressCell: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if let text = textField.text, let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)

            if cityTextView.containsObject(textfield: textField) == true {
                delivery?.city = updatedText
            }
            if streetTextView.containsObject(textfield: textField) == true {
                delivery?.street = updatedText
            }
            if houseTextView.containsObject(textfield: textField) == true {
                delivery?.house = updatedText
            }
            if appartmentTextView.containsObject(textfield: textField) == true {
                delivery?.appartment = updatedText
            }
        }

        return true
    }

}
