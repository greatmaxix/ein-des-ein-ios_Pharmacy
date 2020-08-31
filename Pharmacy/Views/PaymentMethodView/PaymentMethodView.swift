//
//  PaymentMethodView.swift
//  Pharmacy
//
//  Created by CGI-Kite on 31.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

class PaymentMethodView: UIView {

    @IBOutlet private weak var radioButton: UIButton!
    @IBOutlet private weak var methodTitle: UILabel!
    @IBOutlet private weak var paymentImageView: UIImageView!
    
    override func awakeFromNib() {
        radioButton.layer.cornerRadius = radioButton.bounds.height / 2
    }
    
    @IBAction private func selectPayment() {
    }
}
