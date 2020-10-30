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

    var deliveryHandle: EmptyClosure?
    var selfHandler: EmptyClosure?

    @IBAction func selectDelivery(_ sender: Any) {
        deliveryHandle?()

        deliveryView.backgroundColor = R.color.welcomeBlue()
        selfView.backgroundColor = .white
    }

    @IBAction func selectSelf(_ sender: Any) {
        selfHandler?()

        deliveryView.backgroundColor = .white
        selfView.backgroundColor = R.color.welcomeBlue()
    }

}
