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

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        corneredView.dropBlueShadow()
    }

    func apply(delivery: DeliveryInfo) {
        sreetLabel.text = "\(delivery.street ?? ""), \(delivery.house ?? "")"
        detailsLabel.text = "\(delivery.apartment ?? "")"
    }

}
