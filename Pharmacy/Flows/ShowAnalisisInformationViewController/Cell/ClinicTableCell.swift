//
//  ClinicTableCell.swift
//  Pharmacy
//
//  Created by Anna Yatsun on 22.02.2021.
//  Copyright © 2021 pharmacy. All rights reserved.
//

import UIKit

class ClinicTableCell: UITableViewCell {
    
    @IBOutlet private var logoImageView: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var addressLabel: UILabel!
    @IBOutlet private var phoneLabel: UILabel!
    @IBOutlet private var mapButton: UIButton!
    @IBOutlet private var orderServiceButton: UIButton!
    
    func apply() {
        self.orderServiceButton.layer.cornerRadius = 12
    }
}
