//
//  FoundMedicineView.swift
//  Pharmacy
//
//  Created by CGI-Kite on 25.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

class FoundMedicineView: UIView {

    @IBOutlet weak var medicineImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        heightAnchor.constraint(equalToConstant: 56).isActive = true
        medicineImageView.layer.cornerRadius = 8
    }
}
