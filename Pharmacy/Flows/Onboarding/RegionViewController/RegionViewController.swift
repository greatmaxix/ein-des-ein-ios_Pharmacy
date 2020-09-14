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
        model.dataSource.assign(tableView: tableView)
        setupNavigation()
        indicatorView.hidesWhenStopped = true
        indicatorView.startAnimating()
    }
    
    private func setupNavigation() {
        navigationController?.isNavigationBarHidden = false
        if let bar = navigationController?.navigationBar as? SimpleNavigationBar {
            bar.barDelegate = self
            bar.title = model.title
            bar.style = .search
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.isNavigationBarHidden = true
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
        
        model.filterRegions(searchText: returnText)
        tableView.reloadData()
    }
    
    func cancelSearch() {
        model.filterRegions(searchText: "")
        tableView.reloadData()
    }
}

extension RegionViewController: RegionOutput {
    
    func reloadRegions() {
        model.dataSource.assign(tableView: tableView)
        tableView.isHidden = false
        indicatorView.stopAnimating()
    }
}
