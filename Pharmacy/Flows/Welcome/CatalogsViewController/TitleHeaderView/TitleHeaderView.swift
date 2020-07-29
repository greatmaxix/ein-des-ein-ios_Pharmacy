//
//  TitleHeaderView.swift
//  Pharmacy
//
//  Created by CGI-Kite on 29.07.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

class TitleHeaderView: UIView {

    @IBOutlet private weak var titleLabel: UILabel!
    
    var title: String? {
        willSet {
            titleLabel.text = newValue
        }
    }
}
