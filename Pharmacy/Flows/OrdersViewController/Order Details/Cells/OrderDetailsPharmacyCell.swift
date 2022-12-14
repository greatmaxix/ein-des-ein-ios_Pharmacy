//
//  OrderDetailsPharmacyCell.swift
//  Pharmacy
//
//  Created by Mikhail Timoscenko on 02.11.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

class OrderDetailsPharmacyCell: UITableViewCell {

    @IBOutlet weak var corneredView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var phoneStackView: UIStackView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        corneredView.dropBlueShadow()
    }

    func apply(pharm: PharmacyOrder) {
        nameLabel.text = pharm.name
        addressLabel.text = pharm.location
        phoneLabel.text = pharm.phone
        if let url = pharm.imageURL {
            logoImage.loadImageBy(url: url)
        }
    }
}
