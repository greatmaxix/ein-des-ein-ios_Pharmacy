//
//  ProductCategoryTableViewCell.swift
//  Pharmacy
//
//  Created by Anton Bal’ on 13.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

final class ProductCategoryTableViewCell: HighlightedTableViewCell, ContainerView {

    private enum GUI {
        static let cornerRadius: CGFloat = 8
    }
    @IBOutlet var categoryName: UILabel!
    
    @IBOutlet internal weak var containerView: UIView!
    @IBOutlet private weak var imageLabel: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = GUI.cornerRadius
        containerView.dropBlueShadow()
        categoryName.text = R .string.localize.product_categoriy.localized()
    }
    
    func apply(product: Product) {
        titleLabel.text = product.category
        titleLabel.text = R.string.localize.product_categoriy.localized()
    }
}
