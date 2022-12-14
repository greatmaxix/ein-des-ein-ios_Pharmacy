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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = R.color.lightGray()
        title = model.title
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        tableView.backgroundColor = R.color.lightGray()
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        searchController.searchResultsUpdater = self
        searchController.setupSearchBar()
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
