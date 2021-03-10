//
//  ClinicsListController.swift
//  Pharmacy
//
//  Created by Anna Yatsun on 28.02.2021.
//  Copyright © 2021 pharmacy. All rights reserved.
//

import UIKit



protocol ClinicsListControllerInput: ClinicListModelOutput {}
protocol ClinicsListControllerOutput: ClinicListModellInput {}

class ClinicsListController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var model: ClinicsListControllerOutput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let model = ClinicListModel(parent: nil)
        model.output = self
        self.model = model
        
        model.load()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
}

extension ClinicsListController: ClinicsListControllerInput {
    func didLoad(models: [ClinicModel]) {
        
    }
    
    func didFetchError(error: Error) {
        
    }
}

extension ClinicsListController: UITableViewDelegate {
    
}

extension ClinicsListController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.clinicModelList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(at: indexPath, cellType: ClinicTableCell.self)
        let clinic = self.model.clinicModelList[indexPath.row]
        cell.apply(model: clinic, mapAction: { [weak self] in
            self?.model.showOnMap(model: clinic)
        })
        
        return cell
    }
}
