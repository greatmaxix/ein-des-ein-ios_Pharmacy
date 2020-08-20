//
//  SimpleNavigationBarView.swift
//  Pharmacy
//
//  Created by CGI-Kite on 19.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

class SimpleNavigationBarView: UIView {

    @IBOutlet weak var frontView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    override func awakeFromNib() {
        frontView.layer.cornerRadius = 10
        frontView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        dropBlueShadow()
    }
}
