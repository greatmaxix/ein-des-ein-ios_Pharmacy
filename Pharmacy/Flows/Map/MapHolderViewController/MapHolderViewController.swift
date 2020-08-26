//
//  FarmacySelectionViewController.swift
//  Pharmacy
//
//  Created by CGI-Kite on 25.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit
import TTGTagCollectionView

protocol SegmentedControlDelegate: AnyObject {
    
    var controlTitles: [String] {
        get
        set
    }
    
    func selectedScreenChanged(index: Int)
}

final class MapHolderViewController: UIViewController {
    
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet private weak var messageView: UIView!
    @IBOutlet weak var messageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var selectionBackground: UIView!
    
    var model: MapHolderDelegate!
    weak var segmentedControlDelegate: SegmentedControlDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func addChild(_ childController: UIViewController) {
        
        super.addChild(childController)
        
        if let vc: MapViewController = childController as? MapViewController {
            
        }
    }
    
    private func setupUI() {
        model.openMap()
        segmentedControlDelegate = self
        selectionBackground.dropBlueShadow()
        
        selectionBackground.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        selectionBackground.layer.cornerRadius = 8
    }
    
    private func setupLocalization() {
        
    }
    
    // MARK: - Actions
    
    @IBAction func screenChanged(_ sender: UISegmentedControl) {
        
        segmentedControlDelegate?.selectedScreenChanged(index: sender.selectedSegmentIndex)
    }
}

extension MapHolderViewController: SegmentedControlDelegate {
    
    var controlTitles: [String] {
        get {
            [R.string.localize.farmaciesListList(), R.string.localize.farmaciesListMap()]
        }
        set {
            for i in 0..<newValue.count {
                segmentedControl.setTitle(newValue[i], forSegmentAt: i)
            }
        }
    }
    
    func selectedScreenChanged(index: Int) {
        if index == 0 {
            model.openMap()
        } else {
            model.openFarmacyList()
        }
    }
    
}
