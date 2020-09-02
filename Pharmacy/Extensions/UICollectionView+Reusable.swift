//
//  UICollectionView+Reusable.swift
//  Pharmacy
//
//  Created by Sapa Denys on 02.09.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    final func registerReusableCell<T: UICollectionViewCell>(cellType: T.Type) where T: NibReusable {
        register(cellType.nib, forCellWithReuseIdentifier: cellType.reuseIdentifier)
    }
    
    final func registerReusableCell<T: UICollectionViewCell>(cellType: T.Type) {
        
        register(cellType.self, forCellWithReuseIdentifier: cellType.reuseIdentifier)
    }
    
    final func dequeueReusableCell<T: UICollectionViewCell>(_ cellType: T.Type = T.self,
                                                            at indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: cellType.reuseIdentifier,
                                             for: indexPath) as? T else {
                                                fatalError(
                                                    "Failed to dequeue a cell with identifier \(cellType.reuseIdentifier) "
                                                        + "matching type \(cellType.self). "
                                                        + "Check that the reuseIdentifier is set properly in your XIB/Storyboard "
                                                        + "and that you registered the cell beforehand"
                                                )
        }
        
        return cell
    }
}

extension UICollectionViewCell: CellReusable { }
