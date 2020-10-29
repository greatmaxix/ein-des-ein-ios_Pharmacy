//
//  SubcategoryViewController.swift
//  Pharmacy
//
//  Created by Egor Bozko on 29.10.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

class SubcategoryViewController: TableDataSourceViewController {

    var model: SubcategoryModelInput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model.load()
        setupUI()
    }
    
    private func setupUI() {
        title = model.title
        tableView.backgroundColor = view.backgroundColor
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.tableFooterView = UIView()
    }
}

// MARK: - CatalogsModelOutput

extension SubcategoryViewController: SubcategoryModelOutput {
    func didLoadCategories() {
        model.categoryDataSource.assign(tableView: tableView)
    }
}

// MARK: - UICollectionViewDelegate

extension SubcategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        model.didSelectCategoryBy(indexPath: indexPath)
    }
}
