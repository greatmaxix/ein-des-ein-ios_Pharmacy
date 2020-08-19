//
//  TableCellSection.swift
//  KyivPost
//
//  Created by Anton Bal’ on 13.07.2020.
//  Copyright © 2020 KyivPost. All rights reserved.
//

import UIKit

protocol TableCellSection {
    func reuseIdentifier() -> String
    func cellType() -> UITableViewCell.Type?
    func apply(cell: UITableViewCell)
    func config(cell: UITableViewCell)
}

extension TableCellSection {
    func config(cell: UITableViewCell) {}
    func reuseIdentifier() -> String {
        String(describing: self)
    }
}
