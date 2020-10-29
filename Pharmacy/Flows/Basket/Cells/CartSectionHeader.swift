//
//  CartSectionHeader.swift
//  Pharmacy
//
//  Created by Mikhail Timoscenko on 28.10.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit
import Kingfisher

class CartSectionHeader: UITableViewHeaderFooterView {

    @IBOutlet weak var corneredView: UIView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!

    override class func awakeFromNib() {
        super.awakeFromNib()
    }

    func apply(order: PharmCartOrder) {

        nameLabel.text = order.name
        locationLabel.text = order.location
        if let url = order.imageURL {
            logoImageView.loadImageBy(url: url)
        }

        corneredView.dropBlueShadow()
    }

    //    @IBOutlet weak var logoImageView: UIImageView!
//    @IBOutlet weak var nameLabel: UILabel!
//    @IBOutlet weak var locationLabel: UILabel!
//    @IBOutlet weak var selectorButton: UIButton!
//
//    @IBAction func selectionTapped(_ sender: Any) {
//
//    }

}
