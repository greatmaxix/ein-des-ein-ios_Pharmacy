//
//  FarmacyListViewController.swift
//  Pharmacy
//
//  Created by CGI-Kite on 25.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

class MapFarmacyListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var model: FarmacyListInput!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        model.load()

        model.dataSourse.assign(tableView: tableView)
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
    }
}

extension MapFarmacyListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}

extension MapFarmacyListViewController: FarmacyListOutput {}

extension MapFarmacyListViewController: SegmentedControlDelegate {
    
    func selectedScreenChanged(index: Int) {
        //
    }
}
