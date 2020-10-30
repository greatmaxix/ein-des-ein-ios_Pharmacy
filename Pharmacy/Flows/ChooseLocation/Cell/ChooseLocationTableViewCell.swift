//
//  ChooseLocationTableViewCell.swift
//  Pharmacy
//
//  Created by Sergey berdnik on 29.10.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import UIKit

class ChooseLocationTableViewCell: UITableViewCell {
    
    private enum GUI {
        static let cornerRadius: CGFloat = 8
    }
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var applyView: UIImageView!
    @IBOutlet internal weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyView.isHidden = true
        containerView.layer.cornerRadius = GUI.cornerRadius
    }
    
    override func prepareForReuse() {
        self.applyView.isHidden = true
    }
    
    func apply(title: String) {
        titleLabel.text = title
    }
    
    func selectedCell() {
        UIView.transition(with: applyView, duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: {[weak self] in
                            self?.applyView.isHidden = false
                      })
        
    }
}
