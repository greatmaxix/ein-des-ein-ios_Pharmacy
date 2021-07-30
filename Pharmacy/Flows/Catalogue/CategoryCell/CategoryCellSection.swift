//
//  CategoryCellSection.swift
//  Pharmacy
//
//  Created by Anton Bal’ on 12.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

enum CategoryCellSection: CollectionCellSection {
    
    case common(category: Category)
    
    func reuseIdentifier() -> String {
        String(describing: self)
    }
    
    func cellType() -> UICollectionViewCell.Type? {
        return CatalogueCollectionViewCell.self
    }
    
    func apply(cell: UICollectionViewCell) {
        switch (self, cell) {
        case let (.common(category), cell) as (CategoryCellSection, CatalogueCollectionViewCell):
            cell.apply(category: category)
        default: break
        }
    }
}
