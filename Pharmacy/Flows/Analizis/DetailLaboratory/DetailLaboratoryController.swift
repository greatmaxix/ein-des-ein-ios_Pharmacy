//
//  ModerDeteilLaboratoryController.swift
//  Pharmacy
//
//  Created by Anna Yatsun on 19.02.2021.
//  Copyright © 2021 pharmacy. All rights reserved.
//

import UIKit

protocol DeteilLaboratoryControllerOutput: DetailLaboratoryModelInput {}
protocol DeteilLaboratoryControllerInput: DetailLaboratoryModelOutput {}


class DetailLaboratoryController: UIViewController, NavigationBarStyled {
    
    @IBOutlet private var tableView: UITableView!
    
    private var models: [LaboratoryDetailModel] = []

    var style: NavigationBarStyle = .normalWithoutSearch
    var model: DeteilLaboratoryControllerOutput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
        setupTableView()
        model.load()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupTitle()
    }
    
    private func configUI() {
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    private func setupTitle() {
        title = "Биохимические"
    }
}

extension DetailLaboratoryController {
    private func setupTableView() {
        self.tableView.register(UINib(resource: R.nib.detailLaboratoryTableViewCell),
                                forCellReuseIdentifier: String(describing: DetailLaboratoryTableViewCell.self))
    }
}

extension DetailLaboratoryController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(at: indexPath, cellType: DetailLaboratoryTableViewCell.self)
        let model = self.models[indexPath.row]
        cell.apply(deteilLaboratory: model)
        
        return cell
    }
}

extension DetailLaboratoryController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        model.didSelectCell(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension DetailLaboratoryController: DeteilLaboratoryControllerInput {
    
    func didLoad(models: [LaboratoryDetailModel]) {
        self.models = models
    }
    
    func didFetchError(error: Error) {
        
    }
}
