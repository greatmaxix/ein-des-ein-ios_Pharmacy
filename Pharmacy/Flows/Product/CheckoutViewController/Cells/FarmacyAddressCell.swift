//
//  FarmacyAddressCell.swift
//  Pharmacy
//
//  Created by CGI-Kite on 31.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

class FarmacyAddressCell: UITableViewCell {

    @IBOutlet private weak var cellBackgroundView: UIView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var phoneLabel: UILabel!
    @IBOutlet private weak var workTimeLabel: UILabel!
    @IBOutlet private weak var mapButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    private func setupUI() {
        cellBackgroundView.layer.cornerRadius = 8
    }
    
    @IBAction func openMap() {
    }
}
