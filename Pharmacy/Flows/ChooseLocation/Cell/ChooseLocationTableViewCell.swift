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
    
    private var region: Region!
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var applyView: UIImageView!
    @IBOutlet internal weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyView.isHidden = true
        containerView.layer.cornerRadius = GUI.cornerRadius
    }
    
    func apply(title: String, item: Region) {
        titleLabel.text = title
        self.region = item
    }
}
