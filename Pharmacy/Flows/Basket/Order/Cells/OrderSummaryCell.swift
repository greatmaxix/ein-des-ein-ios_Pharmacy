//
//  OrderSummaryCell.swift
//  Pharmacy
//
//  Created by Mikhail Timoscenko on 30.10.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

class OrderSummaryCell: UITableViewCell {

    @IBOutlet weak var startPriceLabel: UILabel!
    @IBOutlet weak var deliveryLabel: UILabel!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var totalLabel: UILabel!

    var confirmAction: EmptyClosure?

    func apply(order: PharmCartOrder, valid: Bool) {
        createButton.isEnabled = valid

        startPriceLabel.text = order.totalCost.moneyString(with: "₸")
        totalLabel.text = order.totalCostWithDelivery.moneyString(with: "₸")
        deliveryLabel.text = order.deliveryCost.moneyString(with: "₸")
    }

    @IBAction func confirmOrder(_ sender: Any) {
        confirmAction?()
    }
}
