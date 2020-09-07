//
//  CatalogsViewController.swift
//  Pharmacy
//
//  Created by CGI-Kite on 28.07.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

final class CatalogsViewController: CollectionDataSourceViewController {
    
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    var model: CatalogsModelInput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model.load()
        setupUI()
    }
    
    private func setupUI() {
        title = model.title
        collectionView.backgroundColor = view.backgroundColor
        view.bringSubviewToFront(indicatorView)
        indicatorView.startAnimating()
        model.load()
        collectionView.delegate = self
    }
}

// MARK: - CatalogsModelOutput

extension CatalogsViewController: CatalogsModelOutput {
    func didLoadCategories() {
        model.categoryDataSource.assign(collectionView: collectionView)
        indicatorView.stopAnimating()
    }
}

// MARK: - UICollectionViewDelegate

extension CatalogsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        model.didSelectCategoryBy(indexPath: indexPath)
    }
}
