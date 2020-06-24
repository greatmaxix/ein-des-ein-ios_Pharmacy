//
//  BaseTableViewCell.swift
//  Waldo
//
//  Created by Mishko on 4/7/20.
//  Copyright © 2020 Yaroslav Bykov. All rights reserved.
//

import UIKit

class BaseCellData {
    
    var selectHandler: (() -> Void)?
    
    var nibName: String? {
        return nil
    }

    var cellHeight: CGFloat {
        return 40
    }
    
    var separatorStyle: UITableViewCell.SeparatorStyle {
        
        return .none
    }
}

class BaseTableViewCell: UITableViewCell {
    
    func setup(cellData: BaseCellData) {
        
    }
    
    func setup(representObj: Any) {
        
    }

}
