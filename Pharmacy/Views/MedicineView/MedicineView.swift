//
//  MedicineView.swift
//  Pharmacy
//
//  Created by CGI-Kite on 02.09.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

class MedicineView: UIView {
    
    @IBOutlet private weak var farmacyImageView: UIImageView!

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var typeLabel: UILabel!
    @IBOutlet private weak var factoryLabel: UILabel!
    @IBOutlet private weak var costLabel: UILabel!
    @IBOutlet private weak var countLabel: UILabel!
    
    override func awakeFromNib() {
        farmacyImageView.layer.cornerRadius = 8
    }
    
    func setup() {
        
    }
}
