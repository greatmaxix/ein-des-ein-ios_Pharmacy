//
//  ProductAnalogTableViewCell.swift
//  Pharmacy
//
//  Created by Anton Bal’ on 13.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

final class ProductAnalogTableViewCell: HighlightedTableViewCell, ContainerView {

    private enum GUI {
        static let cornerRadius: CGFloat = 8
    }
    
    @IBOutlet internal weak var containerView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet weak var analogsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = GUI.cornerRadius
        
        analogsLabel.text = R.string.localize.productAnalogs()
    }
    
    func apply(product: Product) {
        titleLabel.text = product.activeSubstances.first
    }
}
