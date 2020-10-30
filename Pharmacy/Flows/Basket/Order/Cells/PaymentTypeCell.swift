//
//  PaymentTypeCell.swift
//  Pharmacy
//
//  Created by Mikhail Timoscenko on 30.10.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

class PaymentTypeCell: UITableViewCell {

    @IBOutlet weak var corneredView: UIView!

    func apply() {
        corneredView.dropBlueShadow()
    }
}
