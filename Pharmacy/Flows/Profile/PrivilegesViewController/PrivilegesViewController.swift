//
//  PrivilegesViewController.swift
//  Pharmacy
//
//  Created by Anna Yatsun on 24.02.2021.
//  Copyright © 2021 pharmacy. All rights reserved.
//

import UIKit

protocol PrivilegesControllerOutput: PrivilegesModelInput {}
protocol PrivilegesControllerInput: PrivilegesModelOutput {}

class PrivilegesViewController: UIViewController, NavigationBarStyled {
    
    var style: NavigationBarStyle = .normalWithoutSearch
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var nextButton: UIButton!
    
    var model: PrivilegesControllerOutput!
    
    var models: [String] = [
        "Пенсионер",
        "Инвалид",
        "Один кормилец в семье",
        "Страховой полис",
        "Многодетная семья",
        "Ветиран ВОВ"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTitle()
    }

    private func configure() {
        self.nextButton.layer.cornerRadius = 18
    }

    @IBAction func nextAction(_ sender: Any) {
        self.model.openAddDocument()
        
    }
    private func setupTitle() {
        if let bar = navigationController?.navigationBar as? SimpleNavigationBar {
            bar.barDelegate = self
            bar.title = "Льготы"
            bar.isLeftItemHidden = false
        }
    }
}
extension PrivilegesViewController {
    private func setupTableView() {
        tableView.separatorStyle = .none
    }
}

extension PrivilegesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(at: indexPath, cellType: PrivilegesCell.self)
        cell.apply(name: self.models[indexPath.row])
        return cell
    }
}

extension PrivilegesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        model.didSelectCell(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension PrivilegesViewController: PrivilegesControllerInput {
    
    func didFetchError(error: Error) {
        
    }
}

extension PrivilegesViewController: SimpleNavigationBarDelegate {
    func leftBarItemAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func rightBarItemAction() {
        
    }
}
