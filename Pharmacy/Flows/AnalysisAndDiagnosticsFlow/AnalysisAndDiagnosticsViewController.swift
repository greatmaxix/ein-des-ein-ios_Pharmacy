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

class AnalysisAndDiagnostics: UIViewController, NavigationBarStyled {
    
    var style: NavigationBarStyle = .normalWithSearch
    
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var topNavBarView: UIView?
    
    var model: AnalysisAndDiagnosticsControllerOutput!
    var types: [TypeOfAnalysis] = []
    
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
    
    func configUI() {
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupUI() {
        if let bar = self.navigationController?.navigationBar as? SimpleWithSearchNavigationBar {
            bar.title =  "Анализы"
            bar.isLeftItemHidden = false
            bar.leftItemTitle = nil
            bar.barDelegate = self
            bar.style = .normalWithSearch
        }
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

// MARK: - SearchBarDelegate
extension AnalysisAndDiagnostics: SearchBarDelegate {
    
    func searchBar(_ searchBar: SearchBar, textDidChange searchText: String) {
        //model.updateSearchTerm(searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: SearchBar) {
        searchBar.endEditing(false)
        // model.processSearch()
    }
    
    func searchBarDidCancel() {
        // model.cleanSearchTerm()
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
        self.types = models
    }
    
    func didFetchError(error: Error) {
        
    }
}

extension AnalysisAndDiagnostics: SimpleWithSearchNavigationBarDelegate {
    
    func leftBarItemAction() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func rightBarItemAction() {
        
    }
}
