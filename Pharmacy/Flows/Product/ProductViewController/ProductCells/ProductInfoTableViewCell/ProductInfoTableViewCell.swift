//
//  ProductInfoTableViewCell.swift
//  Pharmacy
//
//  Created by Anton Bal’ on 13.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

final class ProductInfoTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var fromPriceLabel: UILabel!
    @IBOutlet private weak var toPriceLabel: UILabel!
    
    // MARK: - Public methods
    func apply(product: Product) {
        titleLabel.text = product.name.htmlToString
        subtitleLabel.text = product.releaseForm.htmlToString
        descriptionLabel.text = product.manufacturer.name
        fromPriceLabel.attributedText = NSAttributedString.fromPriceAttributed(for: product.minPrice)
        toPriceLabel.attributedText = NSAttributedString.toPriceAttributed(for: product.maxPrice)
    }
}
