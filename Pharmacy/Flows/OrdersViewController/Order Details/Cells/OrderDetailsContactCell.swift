//
//  OrderDetailsContactCell.swift
//  Pharmacy
//
//  Created by Mikhail Timoscenko on 02.11.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

class OrderDetailsContactCell: UITableViewCell {

    @IBOutlet weak var cornoredView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        cornoredView.dropBlueShadow()
    }

    func apply(contact: DetailedOrderContact) {
        nameLabel.text = contact.name
        phoneLabel.text = contact.phone
        emailLabel.text = contact.email
        emailLabel.isHidden = (contact.email == nil)
    }

}
