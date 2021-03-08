//
//  MyOrderTableViewCell.swift
//  Pharmacy
//
//  Created by Anna Yatsun on 01.03.2021.
//  Copyright © 2021 pharmacy. All rights reserved.
//

import UIKit

class MyOrderTableViewCell: UITableViewCell {

    @IBOutlet var numberOfAnalis: UILabel!
    @IBOutlet var nameOfAnalis: UILabel!
    @IBOutlet var timeOfAnalis: UILabel!
    @IBOutlet var adressClinic: UILabel!
    @IBOutlet var logoImage: UIImageView!
    @IBOutlet var phoneClinic: UILabel!
    @IBOutlet var price: UILabel!
    @IBOutlet var clinicName: UILabel!
    @IBOutlet var backgroundColorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColorView.backgroundColor = .white
        backgroundColorView.clipsToBounds = true
        backgroundColorView.layer.cornerRadius = 8
    }
    
    
    func apply() {
        
    }
    
}
