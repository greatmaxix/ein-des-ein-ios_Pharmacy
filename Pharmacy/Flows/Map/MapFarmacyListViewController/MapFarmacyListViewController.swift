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
    @IBOutlet weak var selectionBackground: UIView!

    var model: FarmacyListInput!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        model.load()

        model.dataSourse.assign(tableView: tableView)
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        
        selectionBackground.dropBlueShadow()
               
        selectionBackground.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        selectionBackground.layer.cornerRadius = 8
    }
}

extension MapFarmacyListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}

extension MapFarmacyListViewController: FarmacyListOutput {}
