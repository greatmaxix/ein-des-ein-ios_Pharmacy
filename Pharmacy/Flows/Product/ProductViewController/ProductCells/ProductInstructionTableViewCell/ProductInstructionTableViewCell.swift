//
//  ProductInstructionTableViewCell.swift
//  Pharmacy
//
//  Created by Anton Bal’ on 13.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

final class ProductInstructionTableViewCell: HighlightedTableViewCell, ContainerView {
    
    @IBOutlet var instructionLabel: UILabel!
    private enum GUI {
        static let cornerRadius: CGFloat = 10
    }
    @IBOutlet weak var instructionDescriptionLabel: UILabel!
    
    @IBOutlet internal weak var containerView: UIView!
    @IBOutlet weak var collapseImageView: UIImageView!
        
    override func awakeFromNib() {
        containerView.layer.cornerRadius = GUI.cornerRadius
        containerView.dropLightBlueShadow()
        instructionLabel.text = R.string.localize.instruction_label.localized()
        instructionDescriptionLabel.isHidden = true
    }
    
    func apply(product: Product) {
        instructionLabel.text = R.string.localize.instruction_label.localized()
        instructionDescriptionLabel.text = product.description
        collapse(product.isDescriptionCollapsed)
    }
    
    func collapse(_ isCollapsed: Bool) {
        instructionDescriptionLabel.isHidden = isCollapsed
        UIView.animate(withDuration: 0.2) {
            let rotated45DegreesState = CGAffineTransform(rotationAngle: -(CGFloat.pi))
            let normalState: CGAffineTransform = .identity
            self.collapseImageView.transform = isCollapsed ? normalState : rotated45DegreesState
        }
    }
}
