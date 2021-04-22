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
    @IBOutlet var typePrivilegesLabel: UILabel!
    
    var model: PrivilegesControllerOutput!
    
    var models: [String] = [
        R.string.localize.privilegy_pensioner.localized(),
        R.string.localize.privilegy_pinvalid.localized(),
        R.string.localize.privilegy_alone_parents.localized(),
        R.string.localize.privilegy_insurence.localized(),
        R.string.localize.privilegy_a_lot_children.localized(),
        R.string.localize.privilegy_vov.localized()
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTitle()
        self.typePrivilegesLabel.text = R.string.localize.privilegy_type.localized()
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
            bar.title = R.string.localize.profilePrivileges()
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
