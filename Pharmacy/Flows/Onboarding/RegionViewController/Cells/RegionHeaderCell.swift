//
//  RegionHeaderCell.swift
//  Pharmacy
//
//  Created by CGI-Kite on 04.09.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

class RegionHeaderCell: UITableViewHeaderFooterView {
    
    @IBOutlet private weak var titleLabel: UILabel!
    
    func apply(title: String) {
        titleLabel.text = title
    }
}
