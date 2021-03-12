//
//  ShowAnalisisInformationViewController.swift
//  Pharmacy
//
//  Created by Anna Yatsun on 22.02.2021.
//  Copyright © 2021 pharmacy. All rights reserved.
//

import UIKit

protocol AnalisInformationControllerOutput: AnalisInformationModelInput {}
protocol AnalisInformationControllerInput: AnalisInformationyModelOutput {}

class AnalisInformationViewController: UIViewController, NavigationBarStyled {
    
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var tableHeight: NSLayoutConstraint!
    @IBOutlet private var infoView: UIView!
        
    var model: AnalisInformationControllerOutput!
    var style: NavigationBarStyle = .normalWithoutSearch
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        model.load()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTitle()
    }
    
    private func configUI() {
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        infoView.layer.cornerRadius = 8
        setupTitle()
    }
    
    private func setupTitle() {
        title = R.string.localize.analisisChoseClinickKlinicheskiy()
    }
    
    @IBAction func showAllAction(_ sender: Any) {
        model.openFilialList()
    }
}

extension AnalisInformationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(at: indexPath, cellType: ClinicTableCell.self)
        let model = self.model.models[indexPath.row]
        cell.apply(model: model, mapAction: { [weak self] in
            self?.model.showOnMap(model: model)
        }, orderAction: { [weak self] in
            self?.model.orderService(model: model)
        }, clinicInfoAction: { [weak self] in
            self?.model.openDeteilClinic(model)
        })
        return cell
    }
}

extension AnalisInformationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        model.didSelectCell(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension AnalisInformationViewController: AnalisInformationControllerInput {
    func didLoad(models: [ClinicModel]) {

    }
    
    func didFetchError(error: Error) {
        
    }
}
