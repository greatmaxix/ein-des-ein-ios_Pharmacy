//
//  PaymentMethodsCell.swift
//  Pharmacy
//
//  Created by CGI-Kite on 31.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

class PaymentMethodsCell: UITableViewCell {

    @IBOutlet weak var paymentStackView: UIStackView!
    
    private var paymentViews: [PaymentMethodView] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        for _ in 0..<3 {
            if let paymentView = R.nib.paymentMethodView(owner: nil, options: nil) {
                paymentViews.append(paymentView)
            }
        }
    }

}
