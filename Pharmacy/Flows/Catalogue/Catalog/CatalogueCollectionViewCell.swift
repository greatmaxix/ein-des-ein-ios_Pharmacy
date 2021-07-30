//
//  CatalogueCollectionViewCell.swift
//  Pharmacy
//
//  Created by Daniiar Erkinov on 26/7/21.
//  Copyright © 2021 pharmacy. All rights reserved.
//

import UIKit

final class CatalogueCollectionViewCell: HighlightedCollectionViewCell, ContainerView {
    
    @IBOutlet internal weak var containerView: UIView!
    @IBOutlet private weak var categoryImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    private enum GUI {
        static let cornerRadius: CGFloat = 10
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = GUI.cornerRadius
        containerView.decorationLightBlackShadow()
        clipsToBounds = false
    }
    
    func apply(category: Category) {
        titleLabel.text = category.title
        
        if !category.imageTitle.isEmpty {
            categoryImageView.image = UIImage(named: category.imageTitle)
        }
    }
}
