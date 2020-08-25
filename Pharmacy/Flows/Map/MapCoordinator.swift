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
    
    func createFlow() -> UIViewController {
        let root =  R.storyboard.map.instantiateInitialViewController()!
        let model: FarmacySelectionModel = FarmacySelectionModel(parent: self)
        root.model = model
        return root
    }
    
    init(configuration: MapFlowConfiguration) {
        super.init(parent: configuration.parent)
        
        addHandler { (event: BasketModelEvent) in
            
        }
    }
}

//MARK: - TabBarEmbedCoordinable

extension MapCoordinator: TabBarEmbedCoordinable {
    var tabItemInfo: TabBarItemInfo {
        return TabBarItemInfo(title: R.string.localize.tabbarBasket(),
                              icon: R.image.tabbarShopping(),
                              highlightedIcon: R.image.tabbarShopping())
    }
}
