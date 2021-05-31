//
//  PharmacyMapListContainerViewController.swift
//  Pharmacy
//
//  Created by Daniiar Erkinov on 31/5/21.
//  Copyright © 2021 pharmacy. All rights reserved.
//

import UIKit

protocol PharmacyMapListContainerOutput: AnyObject {
    func pharmaciesDidLoad()
    func segmentDidChange(to segment: PharmacySegment)
    func loadingError()
}

final class PharmacyMapListContainerViewController: UIViewController, NavigationBarStyled {
    
    var model: PharmacyMapListContainerInput!
    
    var style: NavigationBarStyle { .normalWithoutSearch }
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var selectionBackground: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    private lazy var listViewController: MapFarmacyListViewController? = {
        guard let vc = R.storyboard.product.mapFarmacyListViewController() else { return nil }
        let model = MapFarmacyListModel(parent: model.getEventNodeParent(), pharmacies: model.getPharmacies())
        model.output = vc
        vc.model = model
        return vc
    }()
    
    private lazy var mapViewController: MapViewController? = {
        guard let vc = R.storyboard.product.mapViewController() else { return nil }
        let mapModel = MapModel(parent: model.getEventNodeParent(), medicineId: model.getMedicineId())
        mapModel.output = vc
        vc.model = mapModel
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLocalization()
        model.load()
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
    
    private func setupMapViewController() {
        guard let mapVC = mapViewController else { return }
        removeChild(viewController: mapVC)
        addChild(viewController: mapVC)
    }
    
    private func setupListViewController() {
        guard let listVC = listViewController else { return }
        removeChild(viewController: listVC)
        addChild(viewController: listVC)
    }
    
    private func removeChild(viewController: UIViewController) {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
        viewController.didMove(toParent: nil)
    }
    
    private func addChild(viewController: UIViewController) {
        viewController.willMove(toParent: self)
        self.addChild(viewController)
        self.containerView.addSubview(viewController.view)
        let conststraints = [
            viewController.view.topAnchor.constraint(equalTo: self.containerView.topAnchor),
            viewController.view.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor),
            viewController.view.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor),
            viewController.view.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor)
        ]
        NSLayoutConstraint.activate(conststraints)
        viewController.didMove(toParent: self)
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        model.changeSegment(to: sender.selectedSegmentIndex)
    }
    
    private func setupLocalization() {
        let newValue = [R.string.localize.farmaciesListList(), R.string.localize.farmaciesListMap.localized()]
        if let segmentControl = self.segmentedControl {
            for i in 0 ..< newValue.count where i < segmentControl.numberOfSegments {
                segmentControl.setTitle(newValue[i], forSegmentAt: i)
            }
        }
    }
    
    private func setupChildViewController(onSegment segment: PharmacySegment) {
        switch segment {
        case .list:
            setupListViewController()
        case .map:
            setupMapViewController()
            mapViewController?.set(pharmacies: self.model.getPharmacies())
            mapViewController?.setMarkerPositionsAndPrices()
        }
    }
}

extension PharmacyMapListContainerViewController: PharmacyMapListContainerOutput {
    func pharmaciesDidLoad() {
        setupChildViewController(onSegment: PharmacySegment.map)
    }
    
    func loadingError() {
        PulseLoaderService.hide(from: view)
    }
    
    func segmentDidChange(to segment: PharmacySegment) {
        setupChildViewController(onSegment: segment)
    }
}
