//
//  AnalysisAndDiagnostics.swift
//  Pharmacy
//
//  Created by Anna Yatsun on 17.02.2021.
//  Copyright © 2021 pharmacy. All rights reserved.
//

import UIKit

protocol AnalysisAndDiagnosticsControllerInput: AnalysisAndDiagnosticsModelOutput {}
protocol AnalysisAndDiagnosticsControllerOutput: AnalysisAndDiagnosticsModelInput {}

class AnalysisAndDiagnostics: UIViewController {
    
    @IBOutlet private var emptySearchMessageView: UIView!
    @IBOutlet private var navigationBarBackground: UIView!
    @IBOutlet private var tableView: UITableView!
    
    private let searchController = SearchController(searchResultsController: nil)
    
    var model: AnalysisAndDiagnosticsControllerOutput!
    var isMainController = true
    
    private var loadedTypes: [TypeOfAnalysis] = []
    private var types: [TypeOfAnalysis] = []
    
    deinit {
        model.close()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model.load()
        configUI()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        view.layoutIfNeeded()
    }

    func configUI() {
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupSearchBar() {
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.leftBarButtonItem = .init(image: R.image.icon_back2(), style: .plain, target: self, action: #selector(dismisSelf))
        searchController.setupSearchBar()
        view.bringSubviewToFront(navigationBarBackground)
        navigationBarBackground.layer.cornerRadius = 10.0
        navigationBarBackground.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
    @objc private func dismisSelf() {
        if isMainController {
            self.model.close()
//            self.navigationController?.dismiss(animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func setupUI() {
        self.title = R.string.localize.profileAnalize.localized()
        setupSearchBar()
    }
}

// MARK: - Private methods
extension AnalysisAndDiagnostics {
    
    private func setupTableView() {
        tableView.register(UINib(resource: R.nib.typeOfAnalysisCell),
                           forCellReuseIdentifier: String(describing: TypeOfAnalysisCell.self))
        
    }
}

extension AnalysisAndDiagnostics: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.types.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(at: indexPath, cellType: TypeOfAnalysisCell.self)
        let model = self.types[indexPath.row]
        cell.apply(analisName: model)
        
        return cell
    }
}

// MARK: - UITableViewDataSourcePrefetching
extension AnalysisAndDiagnostics: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
    }
}

// MARK: - UITableViewDelegate
extension AnalysisAndDiagnostics: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        model.didSelectCell(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - AnalysisAndDiagnosticsControllerInput
extension AnalysisAndDiagnostics: AnalysisAndDiagnosticsControllerInput {
    
    func didLoad(models: [TypeOfAnalysis]) {
        loadedTypes = models
        types = models
    }
    
    func didFetchError(error: Error) {
        
    }
}

extension AnalysisAndDiagnostics: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text == "" || searchController.searchBar.text == nil {
            emptySearchMessageView.isHidden = true
            types = loadedTypes
            tableView.reloadData()
            
            return
        }
        
        let filtered = self.loadedTypes.filter { ($0.analisName?.contains(searchController.searchBar.text ?? "") ?? false) }
        if filtered.isEmpty {
            emptySearchMessageView.isHidden = false
            types = []
            tableView.reloadData()
        } else {
            emptySearchMessageView.isHidden = true
            types = filtered
            tableView.reloadData()
        }
    }
}

