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
    
    let root: MapViewController = R.storyboard.map.instantiateInitialViewController()!
    
    func createFlow() -> UIViewController {
        let model = MapModel(parent: self)
        model.output = root
        root.model = model
        return root
    }
    
    init(configuration: MapFlowConfiguration) {
        super.init(parent: configuration.parent)
                
        addHandler { [weak self] (event: MapEvent) in
            switch event {
            case .openFarmacyList:
                self?.presentFarmaciesList()
            }
        }
    }
    
    func presentFarmaciesList() {
        let vc = R.storyboard.map.mapFarmacyListViewController()!
        vc.model = MapFarmacyListModel(parent: self)
        root.navigationController?.pushViewController(vc, animated: true)
    }
}
