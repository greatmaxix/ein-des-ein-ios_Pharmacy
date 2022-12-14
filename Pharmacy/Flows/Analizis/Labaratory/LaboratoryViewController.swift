//
//  LaboratoryViewController.swift
//  Pharmacy
//
//  Created by Anna Yatsun on 18.02.2021.
//  Copyright © 2021 pharmacy. All rights reserved.
//

import UIKit

protocol LaboratoryControllerOutput: LaboratoryModelInput {}
protocol LaboratoryControllerInput: LaboratoryModelOutput {}

class LaboratoryViewController: UIViewController, NavigationBarStyled {
        
    var style: NavigationBarStyle = .normalWithoutSearch
    
    var model: LaboratoryControllerOutput!
    private var models: [LaboratoryResearchModel] = []
    
    @IBOutlet private var tableView: UITableView?

    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        setupTableView()
        model.load()
    }
    
    private func configUI() {
        title = "Лабораторные"
        tableView?.separatorStyle = .none
        tableView?.delegate = self
        tableView?.dataSource = self
    }
}


extension LaboratoryViewController {
    private func setupTableView() {
        self.tableView?.register(UINib(resource: R.nib.laboratoryTableViewCell),
                           forCellReuseIdentifier: String(describing: LaboratoryTableViewCell.self))
    }
}


extension LaboratoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(at: indexPath, cellType: LaboratoryTableViewCell.self)
        let model = self.models[indexPath.row]
        cell.apply(laboratory: model)
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension LaboratoryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        model.didSelectCell(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - AnalysisAndDiagnosticsControllerInput
extension LaboratoryViewController: LaboratoryControllerInput {
    
    func didLoad(models: [LaboratoryResearchModel]) {
        self.models = models
    }
        
    func didFetchError(error: Error) {
        
    }
}
