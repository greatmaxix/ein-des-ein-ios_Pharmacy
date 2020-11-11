//
//  OrderedProductCell.swift
//  Pharmacy
//
//  Created by Mikhail Timoscenko on 30.10.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

class OrderedProductCell: UITableViewCell {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var manufacturerLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var corneredView: UIView!

    func apply(product: CartMedicine) {
        corneredView.dropBlueShadow()

        nameLabel.text = product.name.htmlToString
        infoLabel.text = product.releaseForm.htmlToString
        countLabel.text = "X " + String(product.productCount)
        priceLabel.text = product.price?.moneyString(with: "₸")
        manufacturerLabel.text = product.manufacturerName

        if let url = URL(string: product.pictureUrls.first ?? "") {
            logoImageView.loadImageBy(url: url)
        }
    }

}
