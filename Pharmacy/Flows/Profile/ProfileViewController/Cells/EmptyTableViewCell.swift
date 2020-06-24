//
//  EmptyTableViewCell.swift
//  testProjs7472
//
//  Created by CGI-Kite on 23.06.2020.
//  Copyright © 2020 none. All rights reserved.
//

import UIKit

class EmptyTableViewCellData: BaseCellData {
    
    override var nibName: String? {
        return String(describing: EmptyTableViewCell.self)
    }
    override var cellHeight: CGFloat {
        return height
    }
    
    init(height: CGFloat = 0, color: UIColor? = nil) {
        self.height = height
        self.color = color
    }
    
    var height: CGFloat = 0
    var color: UIColor?
}

class EmptyTableViewCell: BaseTableViewCell {

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        selectionStyle = .none
    }
    
    override func setup(cellData: BaseCellData) {
        if let cd: EmptyTableViewCellData = cellData as? EmptyTableViewCellData {
            backgroundColor = cd.color
        }
    }
}
