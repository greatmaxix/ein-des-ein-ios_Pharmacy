//
//  FarmacyListViewController.swift
//  Pharmacy
//
//  Created by CGI-Kite on 25.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

class MapFarmacyListViewController: UIViewController, NavigationBarStyled {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var selectionBackground: UIView!
    @IBOutlet private weak var filterControl: UISegmentedControl!
    
    var model: FarmacyListInput!
    
    var style: NavigationBarStyle { .normalWithoutSearch }
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBar()
    }
    
    func setupNavBar() {
        if let navController = navigationController as? SearchNavigationController,
           let navBar = navController.navigationBar as? NavigationBar {
            navigationItem.setHidesBackButton(true, animated: false)
            navBar.smallNavBarTitleLabel.text = R.string.localize.farmaciesListTitle.localized()
        } else {
            title = R.string.localize.farmaciesListTitle.localized()
        }
    }
    
    func setupLocalization() {
        filterControl.setTitle(R.string.localize.farmaciesListByPrice(), forSegmentAt: 0)
        filterControl.setTitle(R.string.localize.farmaciesListByDistance(), forSegmentAt: 1)
        filterControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: R.color.welcomeBlue()], for: .selected)
        filterControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: R.color.welcomeBlue()], for: .normal)
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
            PulseLoaderService.showAdded(to: view)
        case false:
            PulseLoaderService.hide(from: view)
        }
    }
}
