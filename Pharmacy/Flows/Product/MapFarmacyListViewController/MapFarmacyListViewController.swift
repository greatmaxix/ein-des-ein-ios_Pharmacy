//
//  FarmacyListViewController.swift
//  Pharmacy
//
//  Created by CGI-Kite on 25.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit
import MBProgressHUD

class MapFarmacyListViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var selectionBackground: UIView!
    @IBOutlet private weak var filterControl: UISegmentedControl!
    
    private lazy var activityIndicator: MBProgressHUD = {
        setupActivityIndicator()
    }()
    
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
        setupLocalization()
    }
    
    func setupLocalization() {
        title = R.string.localize.farmaciesListTitle()
        filterControl.setTitle(R.string.localize.farmaciesListByPrice(), forSegmentAt: 0)
        filterControl.setTitle(R.string.localize.farmaciesListByDistance(), forSegmentAt: 1)
    }
}

extension MapFarmacyListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}

extension MapFarmacyListViewController: FarmacyListOutput {
    func addingToCart(indicatorShow: Bool) {
        switch indicatorShow {
        case true:
            activityIndicator.show(animated: true)
        case false:
            activityIndicator.hide(animated: true)
        }
    }
}
