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

    var pdfHandler: EmptyClosure?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        corneredView.dropCellLightBlueShadow()
    }

    func apply(receipt: UserReceipt) {
        idLabel.text = "№ \(receipt.id)"
        productLabel.text = receipt.text?.htmlToString
        amountLabel.text = "QNT \(receipt.amount ?? 0)"
        authorLabel.text = receipt.doctorName

        var dateString: String = ""

        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd.MM.YY"

        if let date = dateFormatterGet.date(from: receipt.validTill ?? "") {
            dateString = dateFormatterPrint.string(from: date)
        } else {
            dateString = receipt.validTill ?? ""
        }

        stateView.backgroundColor = receipt.status == "active" ? R.color.welcomeGreen() : R.color.greyText()
        stateLabel.text = receipt.status == "active" ? "Активен до \(dateString)" : "Завершен \(dateString)"
    }
    
    @IBAction func download(_ sender: Any) {
        pdfHandler?()
    }
}
