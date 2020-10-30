//
//  CreateOrderContactInfoCell.swift
//  Pharmacy
//
//  Created by Mikhail Timoscenko on 29.10.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

//protocol CellContactInforationProtocol {
//    <#requirements#>
//}

class CreateOrderContactInfoCell: UITableViewCell {

    @IBOutlet weak var nameTextView: TextInputView!
    @IBOutlet weak var phoneTextView: TextInputView!
    @IBOutlet weak var emailTextView: TextInputView!

    func apply() {
        let user = UserSession.shared.user

        nameTextView.contentType = .name
        nameTextView.placeholder = "Имя"
        nameTextView.text = user?.name

        phoneTextView.contentType = .phone
        phoneTextView.placeholder = ""
        phoneTextView.text = user?.phone

        emailTextView.contentType = .email
        emailTextView.placeholder = "Почта"
        emailTextView.text = user?.email
    }
}
