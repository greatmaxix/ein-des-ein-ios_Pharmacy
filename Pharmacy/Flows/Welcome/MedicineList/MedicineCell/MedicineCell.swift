//
//  MedicineCell.swift
//  Pharmacy
//
//  Created by CGI-Kite on 03.07.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

final class MedicineCell: BaseTableViewCell {
    
    @IBOutlet private weak var farmacyImageView: UIImageView!
    @IBOutlet private weak var likedButton: UIButton!
    @IBOutlet private weak var buyButton: UIButton!
    @IBOutlet private weak var receipeButton: UIButton!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var typeLabel: UILabel!
    @IBOutlet private weak var factoryLabel: UILabel!
    @IBOutlet private weak var costLabel: UILabel!
    
    var addToFavoritesHandler: (() -> Void)?
    var addToPurchesesHandler: (() -> Void)?
    
    
    func apply(medicine: Medicine) {
        titleLabel.text = medicine.tittle
        costLabel.text = medicine.price
        costLabel.attributedText = NSAttributedString.fromPriceAttributed(for: medicine.price, currency: medicine.currency)
        
        if let url = medicine.imageURL {
            farmacyImageView.loadImageBy(url: url)
        }
    }
    
    //MARK: - Actions
    
    @IBAction private func likeAction(sender: UIButton) {
        sender.isSelected.toggle()
    }
    
    @IBAction private func buyAction(sender: UIButton) {
        sender.isSelected.toggle()
    }
}