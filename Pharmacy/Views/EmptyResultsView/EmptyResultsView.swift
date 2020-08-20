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
    
    func setup(title: String, decription: String, buttonTitle: String) {
        titleLabel.text = title
        descriptionLabel.text = description
        confirmButton.setTitle(buttonTitle, for: .normal)
    }
}
