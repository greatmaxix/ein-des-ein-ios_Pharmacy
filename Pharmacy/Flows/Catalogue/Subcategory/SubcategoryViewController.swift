//
//  SubcategoryViewController.swift
//  Pharmacy
//
//  Created by Egor Bozko on 29.10.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

class SubcategoryViewController: TableDataSourceViewController {

    @IBOutlet weak var navigationBackgorundView: UIView!
    
    var model: SubcategoryModelInput!
    private let searchController = SearchController(searchResultsController: nil)
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        view.layoutIfNeeded()
    }
    
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
        searchController.searchResultsUpdater = self
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        view.sendSubviewToBack(tableView)
        navigationBackgorundView.layer.cornerRadius = 10.0
        navigationBackgorundView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
}

// MARK: - CatalogsModelOutput

extension SubcategoryViewController: SubcategoryModelOutput {
    var isSearching: Bool {
        return !(searchController.searchBar.text?.isEmpty ?? false)
    }
    
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

extension SubcategoryViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        model.search(category: searchController.searchBar.text ?? "")
        tableView.reloadData()
    }
}
