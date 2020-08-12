//
//  CategoryCollectionViewCell.swift
//  Pharmacy
//
//  Created by Anton Bal’ on 12.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

final class CategoryCollectionViewCell: UICollectionViewCell {
    
    private enum GUI {
        static let cornerRadius: CGFloat = 8
    }
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = GUI.cornerRadius
        imageView.layer.cornerRadius = GUI.cornerRadius
        containerView.dropLightBlueShadow()
        clipsToBounds = false
    }
    
    func apply(category: Category){
        titleLabel.text = category.title
        
        if let url = category.imageURL {
            imageView.loadImageBy(url: url)
        }
    }
}
