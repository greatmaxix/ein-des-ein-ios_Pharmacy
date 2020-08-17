//
//  ProductDescriptionTableViewCell.swift
//  Pharmacy
//
//  Created by Anton Bal’ on 13.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

final class ProductDescriptionTableViewCell: UITableViewCell {

    @IBOutlet private weak var descriptionLabel: UILabel!
    
    func apply(product: Product) {
        descriptionLabel.text = product.description
    }
}
