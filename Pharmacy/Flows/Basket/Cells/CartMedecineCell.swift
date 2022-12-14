//
//  CartMedecineCell.swift
//  Pharmacy
//
//  Created by Mikhail Timoscenko on 28.10.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

class CartMedecineCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var medTypeLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!

    var increaseHandler: EmptyClosure?
    var decreaseHandler: EmptyClosure?
    var deleteHandler: EmptyClosure?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func apply(medecine: CartMedicine) {
        nameLabel.text = medecine.name.htmlToString
        medTypeLabel.text = medecine.releaseForm.htmlToString
        infoLabel.text = medecine.manufacturerName
        amountLabel.text = String(medecine.productCount)
        priceLabel.text = medecine.price?.moneyString(with: "₸")

        if let url = URL(string: medecine.pictureUrls.first ?? "") {
            logoImageView.loadImageBy(url: url)
        }
    }

    @IBAction func decrease(_ sender: Any) {
        decreaseHandler?()
    }

    @IBAction func increase(_ sender: Any) {
        increaseHandler?()
    }
    
    @IBAction func deletePosition(_ sender: Any) {
        deleteHandler?()
    }
}
