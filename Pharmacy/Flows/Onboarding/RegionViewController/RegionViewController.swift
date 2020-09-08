//
//  RegionViewController.swift
//  Pharmacy
//
//  Created by CGI-Kite on 04.09.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

final class RegionViewController: UIViewController {
    
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var alphabetView: AlphabetView!
    
    var model: RegionInput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        model.load()
        setupNavigation()
    }
    
    func setupNavigation() {
        navigationController?.isNavigationBarHidden = false
        if let bar = navigationController?.navigationBar as? SimpleNavigationBar {
            bar.barDelegate = self
            bar.title = model.title
            bar.searchDelegate = self
            bar.style = .search
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
        super.viewWillDisappear(animated)
    }
    
    @IBAction func useCurrentLocation(_ sender: UIButton) {
    }
    
    @objc private func back() {
        model.close()
    }
}

extension RegionViewController: SimpleNavigationBarDelegate {
    
    func leftBarItemAction() {
        model.close()
    }
    
    func rightBarItemAction() {
    }
}

extension RegionViewController: NavigationBarDelegate {
    func navigationBarDidSelectScan() {
    }
    
    func navigationBar(didReturn text: String) {
        model.filterRegions(text: text, tableView: tableView)
    }
}

extension RegionViewController: RegionOutput {
    
    func reloadRegions() {
        model.dataSource.assign(tableView: tableView, alphabetView: alphabetView)
    }
}
