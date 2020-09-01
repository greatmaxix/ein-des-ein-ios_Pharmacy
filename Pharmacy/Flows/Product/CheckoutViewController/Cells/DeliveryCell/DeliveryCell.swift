//
//  DeliveryCell.swift
//  Pharmacy
//
//  Created by CGI-Kite on 31.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

final class DeliveryCell: UITableViewCell {
    
    @IBOutlet private weak var deliveryButton: UIButton!
    @IBOutlet private weak var pickupButton: UIButton!
    @IBOutlet private weak var deliveryImageView: UIImageView!
    @IBOutlet private weak var pickupImageView: UIImageView!
    @IBOutlet private weak var deliveryLabel: UILabel!
    @IBOutlet private weak var pickupLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    private func setupUI() {
        deliveryButton.layer.borderWidth = 2
        deliveryButton.layer.borderColor = R.color.welcomeBlue()?.cgColor
        deliveryButton.layer.cornerRadius = 8
        
        pickupButton.layer.borderWidth = 2
        pickupButton.layer.borderColor = R.color.textDarkBlue()?.cgColor
        pickupButton.layer.cornerRadius = 8
    }
    
    @IBAction private func selectDelivery(_ sender: UIButton) {
        
        let selectedDelivery: Bool = sender == deliveryButton
        
        deliveryButton.layer.borderColor = selectedDelivery ?  R.color.welcomeBlue()?.cgColor : R.color.textDarkBlue()?.cgColor
        deliveryImageView.tintColor = selectedDelivery ?  R.color.welcomeBlue() : R.color.textDarkBlue()
        deliveryLabel.textColor = selectedDelivery ?  R.color.welcomeBlue() : R.color.textDarkBlue()
        deliveryLabel.font = selectedDelivery ? R.font.openSansSemiBold(size: 14) : R.font.openSansRegular(size: 14)
        
        pickupButton.layer.borderColor = !selectedDelivery ?  R.color.welcomeBlue()?.cgColor : R.color.textDarkBlue()?.cgColor
        pickupImageView.tintColor = !selectedDelivery ?  R.color.welcomeBlue() : R.color.textDarkBlue()
        pickupLabel.textColor = !selectedDelivery ?  R.color.welcomeBlue() : R.color.textDarkBlue()
        pickupLabel.font = !selectedDelivery ? R.font.openSansSemiBold(size: 14) : R.font.openSansRegular(size: 14)
    }
}
