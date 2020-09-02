//
//  CatalogsViewController.swift
//  Pharmacy
//
//  Created by CGI-Kite on 28.07.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

final class CatalogsViewController: CollectionDataSourceViewController {
    
    var model: CatalogsModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model.load()
        setupUI()
    }
    
    private func setupUI() {
        title = model.title
        collectionView.backgroundColor = view.backgroundColor
        model.load()
        collectionView.delegate = self
    }
}

// MARK: - CatalogsModelOutput

extension CatalogsViewController: CatalogsModelOutput {
    func didLoadCategories() {
        model.categoryDataSource.assign(collectionView: collectionView)
    }
}

// MARK: - UICollectionViewDelegate

extension CatalogsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        model.didSelectCategoryBy(indexPath: indexPath)
    }
}
