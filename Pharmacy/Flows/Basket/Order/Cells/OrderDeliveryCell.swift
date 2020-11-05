//
//  OrderDeliveryCell.swift
//  Pharmacy
//
//  Created by Mikhail Timoscenko on 29.10.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

class OrderDeliveryCell: UITableViewCell {

    @IBOutlet weak var deliveryView: UIView!
    @IBOutlet weak var selfView: UIView!
    @IBOutlet weak var deliveryLabel: UILabel!
    @IBOutlet weak var deliveryImage: UIImageView!
    @IBOutlet weak var pickupImage: UIImageView!
    @IBOutlet weak var pickupLabel: UILabel!

    var deliveryHandle: EmptyClosure?
    var selfHandler: EmptyClosure?

    func apply() {
        deliveryView.dropBlueShadow()
        selfView.dropBlueShadow()
    }

    @IBAction func selectDelivery(_ sender: Any) {
        deliveryHandle?()

        deliveryView.backgroundColor = R.color.welcomeBlue()
        selfView.backgroundColor = .white

        deliveryLabel.font = R.font.openSansSemiBold(size: 14)
        pickupLabel.font = R.font.openSansRegular(size: 14)
    }

    @IBAction func selectSelf(_ sender: Any) {
        selfHandler?()

        deliveryView.backgroundColor = .white
        selfView.backgroundColor = R.color.welcomeBlue()

        deliveryLabel.font = R.font.openSansRegular(size: 14)
        pickupLabel.font = R.font.openSansSemiBold(size: 14)
    }

}
