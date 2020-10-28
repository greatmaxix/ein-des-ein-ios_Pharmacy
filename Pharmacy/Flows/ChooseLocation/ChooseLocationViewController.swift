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
        
        configUI()
//        setupTableView()
        setupNavBar()
    }
    
    private func configUI() {
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupTableView() {
        tableView.register(viewType: RecentsHeaderView.self)
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
        1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "zxcxzczxc"
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Header"
    }
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        "Footer"
    }
}

extension ChooseLocationViewController: ChooseLocationViewModelOutput {}

// MARK: - SimpleNavigationBarDelegate

extension ChooseLocationViewController: SimpleNavigationBarDelegate {
  func leftBarItemAction() {
    model.close()
  }
  
  func rightBarItemAction() {
    
  }
}
