//
//  CatalogueViewController.swift
//  Pharmacy
//
//  Created by CGI-Kite on 28.07.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

final class CatalogueViewController: UIViewController {
    
    private enum GUI {
        static let defaultContentInset = UIEdgeInsets.all(16)
    }
    
    @IBOutlet weak var navigationBarBackground: UIView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    var contentInset = GUI.defaultContentInset
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let spacing = (contentInset.left + contentInset.right) / 2
        layout.minimumInteritemSpacing = spacing / 2
        layout.minimumLineSpacing = spacing
        let width = (view.bounds.width / 2) - spacing - layout.minimumInteritemSpacing
        layout.itemSize = CGSize(width: width, height: width)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(
            UINib(nibName: String(describing: CatalogueCollectionViewCell.self), bundle: nil),
            forCellWithReuseIdentifier: CatalogueCollectionViewCell.description()
        )
        collectionView.contentInset =  contentInset
        return collectionView
    }()
    
    let tableView = UITableView()
    
    var model: CatalogueModelInput!
    
    private let searchController = SearchController(searchResultsController: nil)
    private var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    private var isViewDidAppear = false
    
    deinit {
        debugPrint("\(Self.self)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model.load()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupSearchBar()
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        view.layoutIfNeeded()
    }
    
    private func setupUI() {
        title = model.title
        view.backgroundColor = .white
//        flowLayoutStyle = .grid(count: 2, height: 167)
        collectionView.backgroundColor = view.backgroundColor
        collectionView.delegate = self
        
        view.addSubview(collectionView)
        collectionView.constraintsToSuperView(insets: .zero)
        
        
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.constraintsToSuperView()
        tableView.backgroundColor = .white
        tableView.register(SubcategoryTableViewCell.nib, forCellReuseIdentifier: SubcategoryTableViewCell.reuseIdentifier)
        tableView.isHidden = true
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50.0
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        setupSearchBar()
    }
    
    func setupSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = R.string.localize.basketEmptyButton.localized()
        searchController.setupSearchBar()
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        view.bringSubviewToFront(navigationBarBackground)
        navigationBarBackground.layer.cornerRadius = 10.0
        navigationBarBackground.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
}

// MARK: - CatalogsModelOutput

extension CatalogueViewController: CatalogueModelOutput {
    
    func reloadFiltered() {
        if isSearchBarEmpty {
            tableView.isHidden = true
            collectionView.isHidden = false
        } else {
            tableView.isHidden = false
            collectionView.isHidden = true
        }
        tableView.reloadData()
        tableView.scrollRectToVisible(.zero, animated: false)
    }
    
    func didLoadCategories() {
        model.categoryDataSource.assign(collectionView: collectionView)
    }
}

// MARK: - UICollectionViewDelegate

extension CatalogueViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        model.didSelectCategoryBy(indexPath: indexPath)
    }
}

extension CatalogueViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.filteredCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SubcategoryTableViewCell.reuseIdentifier) as? SubcategoryTableViewCell
        cell?.apply(category: model.filteredCategories[indexPath.row])
        return cell!
    }
}

extension CatalogueViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        model.didSelectFilteredCategoryBy(indexPath: indexPath)
    }
}

extension CatalogueViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        model.search(category: searchController.searchBar.text ?? "")
    }
}
