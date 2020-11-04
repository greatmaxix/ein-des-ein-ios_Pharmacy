//
//  FarmacyPinView.swift
//  Pharmacy
//
//  Created by CGI-Kite on 25.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

class FarmacyPinView: UIView {
    
    private enum PinColor {
        case low
        case intermediate
        case high
    }

    @IBOutlet private weak var priceLabel: UILabel!
    
    var price: Double = 0 {
        didSet {
            priceLabel.text = "₸\(price)"
        }
    }
    
    override func awakeFromNib() {
        dropBlueShadow()
    }
}
