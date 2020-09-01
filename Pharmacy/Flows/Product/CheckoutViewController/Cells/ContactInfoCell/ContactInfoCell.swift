//
//  ContactInfoCell.swift
//  Pharmacy
//
//  Created by CGI-Kite on 31.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

final class ContactInfoCell: UITableViewCell {

    @IBOutlet private weak var nameInputView: TextInputView!
    @IBOutlet private weak var phoneInputView: TextInputView!
    @IBOutlet private weak var emailInputView: TextInputView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    private func setupUI() {
        nameInputView.contentType = .name
        phoneInputView.contentType = .phone
        emailInputView.contentType = .email
        
        nameInputView.placeholder = R.string.localize.checkoutName()
        phoneInputView.placeholder = R.string.localize.checkoutPhone()
        emailInputView.placeholder = R.string.localize.checkoutEmail()
    }
    
}
