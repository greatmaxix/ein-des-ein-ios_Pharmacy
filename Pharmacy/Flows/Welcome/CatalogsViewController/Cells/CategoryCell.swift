//
//  CategoryCell.swift
//  Pharmacy
//
//  Created by CGI-Kite on 28.07.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

class CategoryCell: BaseTableViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setup(representObj: Any) {
        if let title = representObj as? String {
            
            titleLabel.text = title
        }
    }
}
