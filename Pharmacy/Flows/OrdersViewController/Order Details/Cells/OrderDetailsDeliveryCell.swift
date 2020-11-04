//
//  OrderDetailsDeliveryCell.swift
//  Pharmacy
//
//  Created by Mikhail Timoscenko on 03.11.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

class OrderDetailsDeliveryCell: UITableViewCell {

    @IBOutlet weak var corneredView: UIView!
    @IBOutlet weak var sreetLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var appartmentStackView: UIStackView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        corneredView.dropBlueShadow()
    }

    func apply(delivery: OrderDetailsDelivery) {
        sreetLabel.text = "\(delivery.street ?? ""), \(delivery.house ?? "")"
        detailsLabel.text = "\(delivery.apartment ?? "")"
        if delivery.apartment == nil {
            appartmentStackView.isHidden = true
        } else {
            appartmentStackView.isHidden = false
        }
    }

}
