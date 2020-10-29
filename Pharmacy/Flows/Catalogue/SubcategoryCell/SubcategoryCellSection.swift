//
//  SubcategoryCellSection.swift
//  Pharmacy
//
//  Created by Egor Bozko on 29.10.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

enum SubcategoryCellSection: TableCellSection {
    
    case common(Category)
    
    func reuseIdentifier() -> String {
        String(describing: self)
    }
    
    func cellType() -> UITableViewCell.Type? {
        SubcategoryTableViewCell.self
    }
    
    func apply(cell: UITableViewCell) {
        switch (self, cell) {
        case let (.common(category), cell) as (SubcategoryCellSection, SubcategoryTableViewCell):
            cell.apply(category: category)
        default: break
        }
    }
}
