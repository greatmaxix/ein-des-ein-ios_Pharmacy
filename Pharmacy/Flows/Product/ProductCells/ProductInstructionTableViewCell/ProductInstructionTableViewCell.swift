//
//  ProductInstructionTableViewCell.swift
//  Pharmacy
//
//  Created by Anton Bal’ on 13.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

final class ProductInstructionTableViewCell: HighlightedTableViewCell, ContainerView {
    
    private enum GUI {
        static let cornerRadius: CGFloat = 8
    }
    
    @IBOutlet internal weak var containerView: UIView!
    
    override func awakeFromNib() {
        containerView.layer.cornerRadius = GUI.cornerRadius
        containerView.dropBlueShadow()
    }
}
