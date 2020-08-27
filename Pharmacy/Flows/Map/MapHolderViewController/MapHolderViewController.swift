//
//  FarmacySelectionViewController.swift
//  Pharmacy
//
//  Created by CGI-Kite on 25.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit
import TTGTagCollectionView
import GoogleMaps

protocol SegmentedControlDelegate: AnyObject {
    
    func selectedScreenChanged(index: Int)
}

final class MapHolderViewController: UIViewController {
    
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var selectionBackground: UIView!
    
    private var toMapButton: UIButton!
    
    var model: MapHolderDelegate!
    weak var segmentedControlDelegate: SegmentedControlDelegate?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func addChild(_ childController: UIViewController) {

        super.addChild(childController)

        if let vc: MapFarmacyListViewController = childController as? MapFarmacyListViewController {
            segmentedControlDelegate = vc
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        toMapButton.removeFromSuperview()
    }
    
    private func setupUI() {
        
        model.openMap()
        segmentedControlDelegate = self
        selectionBackground.dropBlueShadow()
        
        selectionBackground.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        selectionBackground.layer.cornerRadius = 8
        segmentedControl.selectedSegmentIndex = 1
        //swiftlint:disable force_cast
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: R.font.openSansSemiBold(size: 14)!, NSAttributedString.Key.foregroundColor: R.color.welcomeBlue()!], for: .selected)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: R.font.openSansSemiBold(size: 14)!, NSAttributedString.Key.foregroundColor: R.color.gray()!], for: .normal)
        
        title = model.title
        
        toMapButton = UIButton()
        if let bar = navigationController?.navigationBar as? NavigationBar {
            
            toMapButton.translatesAutoresizingMaskIntoConstraints = false
            bar.backButton.addSubview(toMapButton)
            toMapButton.constraintsToSuperView()
            toMapButton.isHidden = true
            toMapButton.addTarget(self, action: #selector(switchToMap), for: .touchUpInside)
        }
    }
    
    @objc private func switchToMap() {
        selectedScreenChanged(index: 1)
        segmentedControl.selectedSegmentIndex = 1
        segmentedControlDelegate = self
    }
    
    // MARK: - Actions
    
    @IBAction func screenChanged(_ sender: UISegmentedControl) {
        
        segmentedControlDelegate?.selectedScreenChanged(index: sender.selectedSegmentIndex)
    }
    
    fileprivate func setSegmetsTitle(titles: [String]? = nil) {
        
        let newValue = titles ?? [R.string.localize.farmaciesListList(), R.string.localize.farmaciesListMap()]
        for i in 0..<newValue.count where i < segmentedControl.numberOfSegments {
            segmentedControl.setTitle(newValue[i], forSegmentAt: i)
        }
    }
}

extension MapHolderViewController: SegmentedControlDelegate {
    
    func selectedScreenChanged(index: Int) {
        
        toMapButton.isHidden = index != 0
        
        if index == 0 {
            model.openFarmacyList()
            setSegmetsTitle(titles: [R.string.localize.farmaciesListByPrice(), R.string.localize.farmaciesListByDistance()])
        } else {
            setSegmetsTitle()
            model.openMap()
        }
    }
    
}
