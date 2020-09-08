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
    @IBOutlet private weak var indicatorView: UIActivityIndicatorView!
    
    var model: RegionInput!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        model.load()
        setupNavigation()
        indicatorView.hidesWhenStopped = true
        indicatorView.startAnimating()
    }
    
    func setupNavigation() {
        navigationController?.isNavigationBarHidden = false
        if let bar = navigationController?.navigationBar as? SimpleNavigationBar {
            bar.barDelegate = self
            bar.title = model.title
            bar.style = .search
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
        super.viewWillDisappear(animated)
    }
    
    @IBAction func useCurrentLocation(_ sender: UIButton) {
        model.startLocationTracking()
        model.openAuthSlide()
        close()
    }
    
    @objc private func close() {
        model.close()
    }
}

extension RegionViewController: SimpleNavigationBarDelegate {
    
    func leftBarItemAction() {
        close()
    }
    
    func rightBarItemAction() {
    }
    
    func search(returnText: String) {
        
        if returnText != "" {
            
            if !(tableView.dataSource is FilterRegionsDataSource) {
                model.filterDataSource.assign(tableView: tableView)
            }
            model.filterDataSource.filterRegions(searchText: returnText)
            tableView.reloadData()
        } else {
            model.dataSource.assign(tableView: tableView)
        }
    }
    
    func cancelSearch() {
        reloadRegions()
    }
}

extension RegionViewController: RegionOutput {
    
    func reloadRegions() {
        model.dataSource.assign(tableView: tableView)
        tableView.isHidden = false
        indicatorView.stopAnimating()
    }
}
