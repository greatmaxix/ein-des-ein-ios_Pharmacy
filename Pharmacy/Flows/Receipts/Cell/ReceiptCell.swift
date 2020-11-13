//
//  ReceiptCell.swift
//  Pharmacy
//
//  Created by Mikhail Timoscenko on 12.11.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

class ReceiptCell: UITableViewCell {

    @IBOutlet weak var corneredView: UIView!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var doctorImageView: UIImageView!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var stateView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        corneredView.dropCellLightBlueShadow()
    }

    func apply(receipt: UserReceipt) {
        idLabel.text = "# \(receipt.id)"
        productLabel.text = receipt.text
        amountLabel.text = "QNT \(receipt.amount)"
        authorLabel.text = receipt.doctorName
        stateView.backgroundColor = receipt.isActive ? R.color.welcomeGreen() : R.color.greyText()
        stateLabel.text = receipt.isActive ? "Активен до \(receipt.activeTill)" : "Завершен \(receipt.activeTill)"
    }
    
}
