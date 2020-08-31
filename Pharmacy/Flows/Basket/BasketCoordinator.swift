//
//  BasketCoordinator.swift
//  Pharmacy
//
//  Created by Anton Bal’ on 07.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import EventsTree

struct BasketFlowConfiguration {
    let parent: EventNode
}

final class BasketCoordinator: EventNode, Coordinator {
    
    func createFlow() -> UIViewController {
        let root =  R.storyboard.basket.instantiateInitialViewController()!
        let model = BasketModel(parent: self)
        root.model = model
        model.output = root
        return root
    }
    
    init(configuration: BasketFlowConfiguration) {
        super.init(parent: configuration.parent)
        
        addHandler { (event: BasketModelEvent) in
            
        }
    }
}

// MARK: - TabBarEmbedCoordinable

extension BasketCoordinator: TabBarEmbedCoordinable {
    var tabItemInfo: TabBarItemInfo {
        return TabBarItemInfo(title: R.string.localize.tabbarBasket(),
                              icon: R.image.tabbarShopping(),
                              highlightedIcon: R.image.tabbarShopping())
    }
}
