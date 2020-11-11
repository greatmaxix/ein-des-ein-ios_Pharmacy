//
//  CartSectionFooterView.swift
//  Pharmacy
//
//  Created by Mikhail Timoscenko on 28.10.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

class CartSectionFooterView: UITableViewHeaderFooterView {

    @IBOutlet weak var corneredView: UIView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var totalCountLabel: UILabel!

    var createOrderHandler: EmptyClosure?

    func apply(order: PharmCartOrder) {
        totalPriceLabel.text = order.totalCostWithDelivery.moneyString(with: "₸")
        totalCountLabel.text = "\(order.totalProducts) товара (ов)"

        corneredView.dropBlueShadowCart()
    }
    @IBAction func createOrder(_ sender: Any) {
        createOrderHandler?()
    }

}
