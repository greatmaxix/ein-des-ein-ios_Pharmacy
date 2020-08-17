//
//  ProductTagsTableViewCell.swift
//  Pharmacy
//
//  Created by Anton Bal’ on 13.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit
import TTGTagCollectionView

final class ProductTagsTableViewCell: UITableViewCell {

    private enum GUI {
        static let backgroundColor = R.color.welcomeBlue()?.withAlphaComponent(0.1)
        static let textColor = R.color.welcomeBlue()
        static let textFont = UIFont.systemFont(ofSize: 14)
    }
    
    @IBOutlet private weak var tagsView: TTGTextTagCollectionView!
    private let config = TTGTextTagConfig()

    override func prepareForReuse() {
        tagsView.removeAllTags()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        config.backgroundColor = GUI.backgroundColor
        config.textColor = GUI.textColor
        config.textFont = GUI.textFont
        config.borderWidth = 0
        config.shadowColor = .clear
    }

    func apply(product: Product) {
        tagsView.addTags(product.tags, with: config)
    }
}
