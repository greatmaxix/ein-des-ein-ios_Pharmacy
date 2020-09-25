//
//  HighlightedTableViewCell.swift
//  Pharmacy
//
//  Created by Anton Bal’ on 14.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

class HighlightedTableViewCell: UITableViewCell, AlphaHighlightedView {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        selectionStyle = .none
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        highlight(highlighted, animated: animated)
    }
}

class HighlightedCollectionViewCell: UICollectionViewCell, AlphaHighlightedView {

    override var isHighlighted: Bool {
        didSet {
             highlight(isHighlighted, animated: true)
        }
    }
}
