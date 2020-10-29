//
//  SubcategoryCell.swift
//  Pharmacy
//
//  Created by Egor Bozko on 29.10.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

final class SubcategoryTableViewCell: HighlightedTableViewCell {
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var decorationView: UIView! {
        didSet {
            decorationView.layer.cornerRadius = 8.0
            decorationView.decorationBlackShadow()
        }
    }
    
    func apply(category: Category) {
        categoryLabel.text = category.title
    }
}
