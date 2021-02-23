//
//  ClinicTableCell.swift
//  Pharmacy
//
//  Created by Anna Yatsun on 22.02.2021.
//  Copyright © 2021 pharmacy. All rights reserved.
//

import UIKit

class ClinicTableCell: UITableViewCell {
    
    @IBOutlet var logoImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var phoneLabel: UILabel!
    @IBOutlet var mapButton: UIButton!
    @IBOutlet var orderServiceButton: UIButton!
    
    func apply() {
        self.orderServiceButton.layer.cornerRadius = 12
    }
}
