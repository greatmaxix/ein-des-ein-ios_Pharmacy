//
//  PharmacyMapListContainerViewController.swift
//  Pharmacy
//
//  Created by Daniiar Erkinov on 31/5/21.
//  Copyright © 2021 pharmacy. All rights reserved.
//

import UIKit

protocol PharmacyMapListContainerOutput: AnyObject {
    func segmentDidChange(to segment: PharmacySegment)
}

final class PharmacyMapListContainerViewController: UIViewController, NavigationBarStyled {
    
    var model: PharmacyMapListContainerModel!
    
    var style: NavigationBarStyle { .normalWithoutSearch }
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var selectionBackground: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    private var listViewController: MapFarmacyListViewController?
    private var mapViewController: MapViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBar()
    }
    
    private func setupNavBar() {
        if let navController = navigationController as? SearchNavigationController,
           let navBar = navController.navigationBar as? NavigationBar {
            navigationItem.setHidesBackButton(true, animated: false)
            navBar.smallNavBarTitleLabel.text = R.string.localize.farmaciesListTitle.localized()
        } else {
            title = R.string.localize.farmaciesListTitle.localized()
        }
    }
    
    private func setupUI() {
        segmentedControl?.selectedSegmentIndex = PharmacySegment.map.rawValue
        
        segmentedControl?.setTitleTextAttributes([NSAttributedString.Key.font: R.font.openSansSemiBold(size: 14)!, NSAttributedString.Key.foregroundColor: R.color.welcomeBlue()!], for: .selected)
        segmentedControl?.setTitleTextAttributes([NSAttributedString.Key.font: R.font.openSansSemiBold(size: 14)!, NSAttributedString.Key.foregroundColor: R.color.gray()!], for: .normal)
        
        selectionBackground?.dropBlueShadow()
        selectionBackground?.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        selectionBackground?.layer.cornerRadius = 8
    }
    
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        model.changeSegment(to: sender.selectedSegmentIndex)
    }
}

extension PharmacyMapListContainerViewController: PharmacyMapListContainerOutput {
    func segmentDidChange(to segment: PharmacySegment) {
        switch segment {
        case .list:
            print("list")
        case .map:
            print("map")
        }
    }
}
