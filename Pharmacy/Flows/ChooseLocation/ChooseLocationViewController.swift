//
//  ChooseLocationViewController.swift
//  Pharmacy
//
//  Created by Sergey berdnik on 28.10.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import UIKit

protocol ChooseLocationViewControllerInput: ChooseLocationViewModelOutput {}
protocol ChooseLocationViewControllerOutput: ChooseLocationViewModelInput {}

class ChooseLocationViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    var model: ChooseLocationViewControllerOutput!
    //private weak var searchBar: SearchBar!
    //var style: NavigationBarStyle = .search
    
    private enum GUI {
        static let backgroundColor = R.color.welcomeBlue()?.withAlphaComponent(0.1)
        static let textColor = R.color.welcomeBlue()
        static let textFont = UIFont.systemFont(ofSize: 14)
    }
    
// MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupNavBar()
        model.load()
    }
    
    private func setupTableView() {
        tableView.backgroundColor = GUI.backgroundColor
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: String(describing: ChooseLocationTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: ChooseLocationTableViewCell.self))
    }
    
    private func setupNavBar() {
      if let bar = navigationController?.navigationBar as? SimpleNavigationBar {
        bar.style = .search
        bar.isLeftItemHidden = false
        bar.isRightItemHidden = false
        bar.title = "Search"
        bar.leftItemTitle = R.string.localize.profileProfile()
        bar.barDelegate = self
      }
    }
}

// MARK: - TableViewDataSource & Delegate

extension ChooseLocationViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.tableViewSections[section].items.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return model.tableViewSections.count
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.backgroundColor = .clear
        view.tintColor = .clear
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(at: indexPath, cellType: ChooseLocationTableViewCell.self)
        cell.selectionStyle = .none
        let item = model.tableViewSections[indexPath.section].items[indexPath.row] as? Region
        cell.apply(title: item!.name, item: item!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        model.tableViewSections[section].header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        model.selected(indexPath: indexPath)
    }
}

extension ChooseLocationViewController: ChooseLocationViewModelOutput {}

// MARK: - SimpleNavigationBarDelegate

extension ChooseLocationViewController: SimpleNavigationBarDelegate {
    
    func leftBarItemAction() {
        model.close()
    }
    
    func reloadTableViewData() {
        tableView.reloadData()
    }
  
    func rightBarItemAction() {
    
    }
}
