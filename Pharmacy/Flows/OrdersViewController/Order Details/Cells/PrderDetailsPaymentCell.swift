//
//  PrderDetailsPaymentCell.swift
//  Pharmacy
//
//  Created by Mikhail Timoscenko on 03.11.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

class OrderDetailsPaymentCell: UITableViewCell {

    @IBOutlet weak var corneredView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()

        corneredView.dropBlueShadow()
    }

}
