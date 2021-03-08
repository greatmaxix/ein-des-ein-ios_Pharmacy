//
//  OrderCell.swift
//  Pharmacy
//
//  Created by Anna Yatsun on 23.02.2021.
//  Copyright © 2021 pharmacy. All rights reserved.
//

import UIKit

class PaymantCell: UITableViewCell {

    @IBOutlet private var paymentType: UIImageView!
    @IBOutlet var notEnableView: UIImageView!
    @IBOutlet var conteinerView: UIView!
    @IBOutlet var namePaymentLabel: UILabel!
    
    func apply(model: PaymentModel, selected: Bool) {
        self.namePaymentLabel.text = model.paymetText
        self.notEnableView.image = selected ? UIImage(named: "radiobutton_checked") : UIImage(named: "unselectedRadio_icon")
        self.paymentType.image = UIImage(named: model.paymetImage ?? "googlePay_icon")
    }
}
    
