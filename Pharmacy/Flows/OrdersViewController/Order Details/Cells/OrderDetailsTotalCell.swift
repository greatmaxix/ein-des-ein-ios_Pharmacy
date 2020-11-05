//
//  OrderDetailsTotalCell.swift
//  Pharmacy
//
//  Created by Mikhail Timoscenko on 03.11.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

class OrderDetailsTotalCell: UITableViewCell {

    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var totalCostLabel: UILabel!
    @IBOutlet weak var deliveryCostLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!

    var actionHandler: EmptyClosure?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = R.color.welcomeBlue()?.cgColor
    }

    func apply(cost: Decimal, isCanceled: Bool) {
        costLabel.text = cost.moneyString(with: "₸")
        deliveryCostLabel.text = "₸ 0"
        totalCostLabel.text = cost.moneyString(with: "₸")
        cancelButton.isHidden = isCanceled
    }

    @IBAction func cancelTapped(_ sender: Any) {
        actionHandler?()
    }
}
