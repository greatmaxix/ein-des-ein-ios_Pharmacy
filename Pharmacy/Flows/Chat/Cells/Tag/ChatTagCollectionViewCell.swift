//
//  ChatTagCollectionViewCell.swift
//  Pharmacy
//
//  Created by Egor Bozko on 18.11.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

class ChatTagCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var tagTitleLabel: UILabel!
    @IBOutlet weak var decorationView: UIView! {
        didSet {
            decorationView.layer.cornerRadius = 8.0
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            decorationView.alpha = isHighlighted ? 1.0 : 0.2
            tagTitleLabel.textColor = isHighlighted ? UIColor.white : R.color.welcomeBlue()
        }
    }
    
    override var isSelected: Bool {
        didSet {
            decorationView.alpha = isSelected ? 1.0 : 0.2
            tagTitleLabel.textColor = isSelected ? UIColor.white : R.color.welcomeBlue()
        }
    }
    
    func apply() {
        
    }
}
