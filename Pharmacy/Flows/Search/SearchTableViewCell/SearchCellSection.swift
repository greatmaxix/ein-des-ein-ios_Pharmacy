//
//  SearchCellSection.swift
//  Pharmacy
//
//  Created by Anton Bal’ on 18.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

enum SearchCellSection: TableCellSection {
    
    case common(String)
    
    func cellType() -> UITableViewCell.Type? {
        SearchTableViewCell.self
    }
    
    func apply(cell: UITableViewCell) {

        switch (self, cell) {
        case let (.common(search), cell) as (SearchCellSection, SearchTableViewCell):
            cell.apply(title: search)
        default:
            return
        }
        
    }
    
}
