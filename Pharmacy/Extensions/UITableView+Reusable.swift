//
//  UITableView+Reusable.swift
//  Pharmacy
//
//  Created by Sapa Denys on 17.09.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

protocol ViewReusable: CellReusable {}

extension UITableView {
    
    final func register<T: UITableViewCell>(cellType: T.Type) where T: NibReusable {
        register(cellType.nib, forCellReuseIdentifier: cellType.reuseIdentifier)
    }
    
    final func register<T: UITableViewCell>(cellType: T.Type) {
        register(cellType.self, forCellReuseIdentifier: cellType.reuseIdentifier)
    }
    
    final func dequeueReusableCell<T: UITableViewCell>(at indexPath: IndexPath, cellType: T.Type = T.self) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: cellType.reuseIdentifier, for: indexPath) as? T else {
            fatalError(
                "Failed to dequeue a cell with identifier \(cellType.reuseIdentifier) "
                    + "matching type \(cellType.self). "
                    + "Check that the reuseIdentifier is set properly in your XIB/Storyboard "
                    + "and that you registered the cell beforehand"
            )
        }
        
        return cell
    }
    
    final func register<T: UITableViewHeaderFooterView>(viewType: T.Type) where T: NibReusable {
        register(viewType.nib, forHeaderFooterViewReuseIdentifier: viewType.reuseIdentifier)
    }
    
    final func dequeueReusableView<T: UITableViewHeaderFooterView>(viewType: T.Type) -> T {
        guard let view = dequeueReusableHeaderFooterView(withIdentifier: viewType.reuseIdentifier) as? T else {
            fatalError(
                "Failed to dequeue a view with identifier \(viewType.reuseIdentifier) "
                    + "matching type \(viewType.self). "
                    + "Check that the reuseIdentifier is set properly in your XIB/Storyboard "
                    + "and that you registered the cell beforehand"
            )
        }
        
        return view
    }
}

extension UITableViewCell: ViewReusable { }
extension UITableViewHeaderFooterView: ViewReusable { }
