//
//  CollectionCellSection.swift
//  Pharmacy
//
//  Created by Anton Bal’ on 12.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

protocol CollectionCellSection {
    func reuseIdentifier() -> String
    func cellType() -> UICollectionViewCell.Type?
    func apply(cell: UICollectionViewCell)
}
