//
//  RegionViewController.swift
//  Pharmacy
//
//  Created by CGI-Kite on 04.09.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

final class RegionViewController: UIViewController, NavigationBarStyled {
    
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var alphabetView: AlphabetView!
    
    var style: NavigationBarStyle {
        .normal
    }
    var model: RegionInput!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        model.load()
        title = model.title
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func useCurrentLocation(_ sender: UIButton) {
    }
    
}

extension RegionViewController: RegionOutput {
    
    func reloadRegions() {
        model.dataSource.assign(tableView: tableView, alphabetView: alphabetView)
    }
}
