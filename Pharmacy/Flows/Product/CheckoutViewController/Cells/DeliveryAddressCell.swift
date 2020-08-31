//
//  DeliveryAddressCell.swift
//  Pharmacy
//
//  Created by CGI-Kite on 31.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

class DeliveryAddressCell: UITableViewCell {

    @IBOutlet private weak var cityInputView: TextInputView!
    @IBOutlet private weak var streetInputView: TextInputView!
    @IBOutlet private weak var houseInputView: TextInputView!
    @IBOutlet private weak var flatNumberInputView: TextInputView!
    @IBOutlet private weak var descriptionTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }

    private func setupUI() {
        cityInputView.contentType = .other
        streetInputView.contentType = .other
        houseInputView.contentType = .other
        flatNumberInputView.contentType = .other
        
        cityInputView.placeholder = R.string.localize.checkoutCity()
        streetInputView.placeholder = R.string.localize.checkoutStreet()
        houseInputView.placeholder = R.string.localize.checkoutHouseNumber()
        flatNumberInputView.placeholder = R.string.localize.checkoutFlatNumber()
    }
}
