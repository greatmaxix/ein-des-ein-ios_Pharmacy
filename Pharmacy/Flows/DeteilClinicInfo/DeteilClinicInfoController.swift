//
//  DeteilClinicInfoController.swift
//  Pharmacy
//
//  Created by Anna Yatsun on 26.02.2021.
//  Copyright © 2021 pharmacy. All rights reserved.
//

import UIKit

protocol DeteilClinicInfoControllerOutput: DeteilClinicInfoModelInput {}
protocol DeteilClinicInfoControllerInput: DeteilClinicInfoModelOutput {}

class DeteilClinicInfoController: UIViewController {
    
    @IBOutlet private var tableView: UITableView!
    
    @IBOutlet var height: NSLayoutConstraint!
    var model: DeteilClinicInfoControllerOutput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        model.load()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTitle()
    }
    
    @IBAction func openInfoAboutClinic(_ sender: Any) {
        model.models.first.map {
            model.openDeteilClinic($0)
        }
    }
    
    @IBAction func showAllList(_ sender: Any) {
        model.showAll()
    }
    
    private func configUI() {
        setupTitle()
    }
    
    private func setupTitle() {
        title = "Инвитро"
    }
}

extension DeteilClinicInfoController {
    private func setupTableView() {
        tableView.register(UINib(resource: R.nib.typeOfAnalysisCell),
                           forCellReuseIdentifier: String(describing: TypeOfAnalysisCell.self))
    }
}

extension DeteilClinicInfoController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(at: indexPath, cellType: TypeOfAnalysisCell.self)
        let model = self.model.models[indexPath.row]
        cell.apply(analisName: model)
        return cell
    }
}

extension DeteilClinicInfoController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        model.didSelectCell(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


extension DeteilClinicInfoController: SimpleNavigationBarDelegate {
    
    func leftBarItemAction() {
        model.close()
    }
    
    func rightBarItemAction() {
        
    }
}

extension DeteilClinicInfoController: DeteilClinicInfoControllerInput {
    func didLoad(models: [TypeOfAnalysis]) {
        self.height.constant = CGFloat(models.count) * model.cellHeight
    }
    
    
    func didFetchError(error: Error) {
        
    }
}
