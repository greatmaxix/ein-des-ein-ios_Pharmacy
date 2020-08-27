//
//  MapCoordinator.swift
//  Pharmacy
//
//  Created by CGI-Kite on 25.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import EventsTree

struct MapFlowConfiguration {
    let parent: EventNode
}

final class MapCoordinator: EventNode, Coordinator {
    
    let root: MapHolderViewController =  R.storyboard.map.instantiateInitialViewController()!
    
    private var farmacyListViewController: MapFarmacyListViewController!
    private var mapViewController: MapViewController!
    
    func createFlow() -> UIViewController {
        return root
    }
    
    init(configuration: MapFlowConfiguration) {
        super.init(parent: configuration.parent)
                
        addHandler { [weak self] (event: FarmacySelectionEvent) in
            switch event {
            case .openMap:
                self?.addMapAsChild()
            case .openFarmacyList:
                self?.addFarmaciesListAsChild()
            }
        }
        
        let mapHolderModel: MapHolderModel = MapHolderModel(parent: self)
        root.model = mapHolderModel
        
        mapViewController = UIStoryboard(resource: R.storyboard.map).instantiateViewController(withIdentifier: "MapViewController") as? MapViewController
        let model = MapModel(parent: mapHolderModel)
        model.output = mapViewController
        mapViewController.model = model
        
        farmacyListViewController = UIStoryboard(resource: R.storyboard.map).instantiateViewController(withIdentifier: "MapFarmacyListViewController") as? MapFarmacyListViewController
        let farmacyModel = MapFarmacyListModel(parent: mapHolderModel)
        farmacyModel.output = farmacyListViewController
        farmacyListViewController.model = farmacyModel
    }
    
    func addMapAsChild() {

        root.contentView.addSubview(mapViewController.view)
        mapViewController.view.constraintsToSuperView()
        root.addChild(mapViewController)
        mapViewController.didMove(toParent: root)
    }
    
    func addFarmaciesListAsChild() {

        root.contentView.addSubview(farmacyListViewController.view)
        farmacyListViewController.view.constraintsToSuperView()
        root.addChild(farmacyListViewController)
        farmacyListViewController.didMove(toParent: root)
    }
}
