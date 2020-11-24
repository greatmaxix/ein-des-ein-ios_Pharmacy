//
//  SearchTableViewCell.swift
//  Pharmacy
//
//  Created by Anton Bal’ on 18.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

final class SearchTableViewCell: HighlightedTableViewCell, ContainerView, NibReusable {
    
    private enum GUI {
        static let cornerRadius: CGFloat = 8
    }
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet internal weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.layer.cornerRadius = GUI.cornerRadius
    }
    
    func apply(title: String) {
        titleLabel.text = title
    }
}
