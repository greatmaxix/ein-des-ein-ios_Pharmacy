//
//  ReadyOrderView.swift
//  Pharmacy
//
//  Created by CGI-Kite on 28.07.2020..
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

class ReadyOrderView: UIView {
    
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var deliveryLable: UILabel!

    var orderNumber: String = ""
    
    override func awakeFromNib() {
        dropBlueShadow()
        layer.cornerRadius = 10
    }
    
    override func didMoveToSuperview() {
        deliveryLable.text = R.string.localize.welcomeDelivery()
        titleLable.text = R.string.localize.welcomeYourOrder() + " " + orderNumber + " "
            + R.string.localize.welcomeReady() + "!"
    }
}
