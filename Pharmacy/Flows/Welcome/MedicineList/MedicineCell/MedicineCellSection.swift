//
//  MedicineCellSection.swift
//  Pharmacy
//
//  Created by Anton Bal’ on 12.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

enum MedicineCellSection: TableCellSection {
    
    case common(Medicine)
    
    func reuseIdentifier() -> String {
        String(describing: self)
    }
    
    func cellType() -> UITableViewCell.Type? {
        MedicineCell.self
    }
    
    func apply(cell: UITableViewCell) {
        switch (self, cell) {
        case let (.common(medicine), cell) as (MedicineCellSection, MedicineCell):
            cell.apply(medicine: medicine)
        default:
            return
        }
    }
}
