//
//  CollectionDataSource.swift
//  Pharmacy
//
//  Created by Anton Bal’ on 12.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

protocol CollectionDataSources: UICollectionViewDataSource {
    associatedtype T
    var cells: [T] { get set }
    func assign(collectionView: UICollectionView)
    func cell(for indexPath: IndexPath) -> T?
}

extension CollectionDataSources {
    func cell(for indexPath: IndexPath) -> T? {
        guard cells.count > indexPath.row else { return nil }
        return cells[indexPath.row]
    }
}

final class CollectionDataSource<T: CollectionCellSection>: NSObject, CollectionDataSources {
    
    var cells = [T]()
    
    var didApplySectionHandler: ((T) -> Void)?
    
    func assign(collectionView: UICollectionView) {
        cells.forEach {
            if let nib = $0.cellType()?.nib {
                collectionView.register(nib, forCellWithReuseIdentifier: $0.reuseIdentifier())
            }
        }
        
        collectionView.dataSource = self
    }

    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let value = cells[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: value.reuseIdentifier(), for: indexPath)
        value.apply(cell: cell)
        didApplySectionHandler?(value)
        return cell
    }
}
