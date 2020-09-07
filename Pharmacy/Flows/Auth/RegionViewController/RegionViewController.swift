//
//  RegionViewController.swift
//  Pharmacy
//
//  Created by CGI-Kite on 04.09.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

class RegionViewController: UIViewController {
    
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var alphabetView: AlphabetView!

    var model: RegionInput!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        model.load()
        title = model.title
    }
    
    @IBAction func useCurrentLocation(_ sender: UIButton) {
    }
    
}

extension RegionViewController: RegionOutput {
    
    func reloadRegions() {
        model.dataSource.assign(tableView: tableView, alphabetView: alphabetView)
    }
}
