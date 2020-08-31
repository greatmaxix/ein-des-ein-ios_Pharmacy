//
//  FarmacySelectionCellSection.swift
//  Pharmacy
//
//  Created by CGI-Kite on 26.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

enum MapFarmacyCellSection: TableCellSection {
    
    case common(String)
    
    func reuseIdentifier() -> String {
        String(describing: self)
    }
    
    func cellType() -> UITableViewCell.Type? {
        MapFarmacyCell.self
    }
    
    func apply(cell: UITableViewCell) {
        switch (self, cell) {
        case let (.common(title), cell) as (MapFarmacyCellSection, MapFarmacyCell):
            cell.apply(title: title)
        default:
            return
        }
    }
}
