//
//  CategoryCollectionViewCell.swift
//  Pharmacy
//
//  Created by Anton Bal’ on 12.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

final class CategoryCollectionViewCell: HighlightedCollectionViewCell, ContainerView {
    
    private enum GUI {
        static let cornerRadius: CGFloat = 8
    }
    
    @IBOutlet internal weak var containerView: UIView!
    @IBOutlet private weak var categoryImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = GUI.cornerRadius
        containerView.decorationBlackShadow()
        clipsToBounds = false
    }
    
    func apply(category: Category) {
        titleLabel.text = category.title
        
        if !category.imageTitle.isEmpty {
            categoryImageView.image = UIImage(named: category.imageTitle)
        }
    }
}
