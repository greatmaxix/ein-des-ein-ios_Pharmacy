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

class AnalisInformationViewController: UIViewController {
    
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var tableHeight: NSLayoutConstraint!
    @IBOutlet private var infoView: UIView!
    
    
    private let cellHeight: CGFloat = 190
    var model: AnalisInformationControllerOutput!
    private var models = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTitle()
    }
    
    @IBAction func openInfoAboutClinic(_ sender: Any) {
        let modelClinic = ClinicModel(clinicName: "", adressClinic: "", imageClinic: "", priceClinic: "")
        model.openDeteilClinic(modelClinic)
    }
    
    @IBAction func orderSrvice(_ sender: Any) {
        model.orderService()
    }
    
    private func configUI() {
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableHeight.constant = CGFloat(3) * cellHeight
        infoView.layer.cornerRadius = 8
        self.setupTitle()
    }
    
    private func setupTitle() {
        if let bar = self.navigationController?.navigationBar as? SimpleWithSearchNavigationBar {
            bar.title = "Клинический"
            bar.style = .normal
            bar.barDelegate = self
        }
    }
}

extension AnalisInformationViewController {
    private func setupTableView() {
        self.tableView.register(UINib(resource: R.nib.detailLaboratoryTableViewCell),
                                forCellReuseIdentifier: String(describing: DetailLaboratoryTableViewCell.self))
    }
}

extension AnalisInformationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(at: indexPath, cellType: ClinicTableCell.self)
        cell.apply()
        return cell
    }
}

extension AnalisInformationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       model.didSelectCell(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


extension AnalisInformationViewController: SimpleWithSearchNavigationBarDelegate {
    
    func leftBarItemAction() {
        model.close()
    }
    
    func rightBarItemAction() {
        
    }
}

extension AnalisInformationViewController: AnalisInformationControllerInput {
    func didLoad(models: [LaboratoryDetailModel]) {
        self.models = ["1", "2"]
        tableHeight.constant = CGFloat(models.count) * cellHeight
    }

    
    func didFetchError(error: Error) {
        
    }
}
