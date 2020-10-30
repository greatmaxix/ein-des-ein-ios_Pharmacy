//
//  FarmacySelectionCellSection.swift
//  Pharmacy
//
//  Created by CGI-Kite on 26.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

struct MapFarmacyCellSection: TableCellSection {
    
    var common: PharmacyModel!
    var addToChartHandler: EmptyClosure?
    
    func reuseIdentifier() -> String {
        String(describing: self)
    }
    
    func cellType() -> UITableViewCell.Type? {
        MapFarmacyCell.self
    }
    
    func apply(cell: UITableViewCell) {
        guard let cell = cell as? MapFarmacyCell else {return}
        cell.apply(pharmacy: self.common)
        cell.addToPurchesesHandler = addToChartHandler
    }
}
