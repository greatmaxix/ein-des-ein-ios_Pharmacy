//
//  ApplyOrderCell.swift
//  Pharmacy
//
//  Created by CGI-Kite on 31.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

final class ApplyOrderCell: UITableViewCell {

    @IBOutlet weak var promocodeButton: UIButton!
    @IBOutlet weak var applyButton: UIButton!
    
    @IBOutlet weak var sumTitleLabel: UILabel!
    @IBOutlet weak var discountTitleLabel: UILabel!
    @IBOutlet weak var deliverySumTitleLabel: UILabel!
    @IBOutlet weak var sumLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var deliverySumLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    private func setupUI() {
        promocodeButton.layer.cornerRadius = promocodeButton.bounds.height / 2
        applyButton.layer.cornerRadius = applyButton.bounds.height / 2
        
        sumTitleLabel.text = R.string.localize.checkoutWhorePrice()
        discountTitleLabel.text = R.string.localize.checkoutDiscount()
        deliverySumTitleLabel.text = R.string.localize.checkoutDelivery()
        priceTitleLabel.text = R.string.localize.checkoutFinalPrice()
        promocodeButton.setTitle(R.string.localize.checkoutPromocode(), for: .normal)
        applyButton.setTitle(R.string.localize.checkoutApplyPurchase(), for: .normal)
    }
}
