//
//  ProductInfoTableViewCell.swift
//  Pharmacy
//
//  Created by Anton Bal’ on 13.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

final class ProductInfoTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var fromPriceLabel: UILabel!
    @IBOutlet private weak var toPriceLabel: UILabel!
    
    func apply(product: Product) {
        titleLabel.text = product.title
        subtitleLabel.text = product.subtitle
        descriptionLabel.text = product.company
        fromPriceLabel.attributedText = NSAttributedString.fromPriceAttributed(for: product.fromPrice, currency: product.currency)
        toPriceLabel.attributedText = NSAttributedString.toPriceAttributed(for: product.fromPrice, currency: product.currency)
    }
}
