//
//  ProductQuestionsTableViewCell.swift
//  Pharmacy
//
//  Created by Anton Bal’ on 13.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

final class ProductQuestionsTableViewCell: HighlightedTableViewCell, ContainerView {
    
    private enum GUI {
        static let cornerRadius: CGFloat = 8
    }
    
    @IBOutlet internal weak var containerView: UIView!
    @IBOutlet weak var questionsLabel: UILabel!
    @IBOutlet weak var askLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = GUI.cornerRadius
        containerView.dropBlueShadow()
        
        questionsLabel.text = R.string.localize.productQuestions()
        askLabel.text = R.string.localize.productAskFarmacept()
    }
}
