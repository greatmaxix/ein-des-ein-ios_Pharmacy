//
//  EmptyResultsView.swift
//  Pharmacy
//
//  Created by CGI-Kite on 20.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

final class EmptyResultsView: UIView {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var imageViewTopConstr: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        confirmButton.layer.cornerRadius = confirmButton.bounds.height / 2
        confirmButton.dropBlueShadow()

        imageViewTopConstr.constant = Const.topSpace()
    }
    
    func setup(title: String, decriptionText: String, buttonTitle: String) {
        titleLabel.text = title
        descriptionLabel.text = decriptionText
        confirmButton.setTitle(buttonTitle, for: .normal)
    }
}

private struct Const {
    
    static func topSpace() -> CGFloat {
        
        let minLogoTopSpace: CGFloat = 30
        let maxLogoTopSpace: CGFloat = 131
        let minScreenHeight: CGFloat = 550
        let maxScreenHeight: CGFloat = 896
        
        let screenHeight = UIScreen.main.bounds.height
        let coef = (screenHeight - minScreenHeight) / (maxScreenHeight - minScreenHeight)
        return coef * maxLogoTopSpace + (1 - coef) * minLogoTopSpace
    }
}
