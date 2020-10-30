//
//  OrderPharmacyCell.swift
//  Pharmacy
//
//  Created by Mikhail Timoscenko on 30.10.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

class OrderPharmacyCell: UITableViewCell {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var corneredView: UIView!

    func apply(order: PharmCartOrder) {
        locationLabel.text = order.location
        nameLabel.text = order.name

        if let url = order.imageURL {
            logoImageView.loadImageBy(url: url)
        }

        corneredView.dropBlueShadow()
    }
    
}
