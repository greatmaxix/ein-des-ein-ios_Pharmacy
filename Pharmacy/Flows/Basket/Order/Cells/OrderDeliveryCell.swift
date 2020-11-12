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
    
    private enum GUI {
        static let applyColor: UIColor = R.color.welcomeBlue()!
        static let disableColor: UIColor = R.color.textDarkBlue()!
    }
    
    func apply() {
        deliveryView.dropBlueShadow()
        selfView.dropBlueShadow()
        
        deliveryImage.image = deliveryImage.image?.withRenderingMode(.alwaysTemplate)
        pickupImage.image = pickupImage.image?.withRenderingMode(.alwaysTemplate)
    }

    @IBAction func selectDelivery(_ sender: Any) {
        deliveryHandle?()
        
        deliveryView.backgroundColor = GUI.applyColor
        deliveryImage.tintColor = GUI.applyColor
        deliveryLabel.textColor = GUI.applyColor
        
        pickupImage.tintColor = GUI.disableColor
        pickupLabel.textColor = GUI.disableColor
        selfView.backgroundColor = .white
        
        deliveryLabel.font = R.font.openSansSemiBold(size: 14)
        pickupLabel.font = R.font.openSansRegular(size: 14)
    }

    @IBAction func selectSelf(_ sender: Any) {
        selfHandler?()

        deliveryView.backgroundColor = .white
        deliveryLabel.textColor = GUI.disableColor
        deliveryImage.tintColor = GUI.disableColor
        
        selfView.backgroundColor = R.color.welcomeBlue()
        pickupImage.tintColor = GUI.applyColor
        pickupLabel.textColor = GUI.applyColor
        
        deliveryLabel.font = R.font.openSansRegular(size: 14)
        pickupLabel.font = R.font.openSansSemiBold(size: 14)
    }
}
