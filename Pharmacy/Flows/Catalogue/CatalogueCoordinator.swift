//
//  CatalogueCoordinator.swift
//  Pharmacy
//
//  Created by Anton Bal’ on 07.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import EventsTree

struct CatalogueFlowConfiguration {
    let parent: EventNode
}

final class CatalogueCoordinator: EventNode, Coordinator {
    
    func createFlow() -> UIViewController {
        let root =  R.storyboard.catalogue.instantiateInitialViewController()!
        let model = CatalogueModel(parent: self)
        root.model = model
        model.output = root
        return root
    }
    
    init(configuration: CatalogueFlowConfiguration) {
        super.init(parent: configuration.parent)
        
        addHandler { (event: BasketModelEvent) in
            
        }
    }
}

//MARK: - TabBarEmbedCoordinable

extension CatalogueCoordinator: TabBarEmbedCoordinable {
    var tabItemInfo: TabBarItemInfo {
        return TabBarItemInfo(title: R.string.localize.tabbarCatalogue(),
                              icon: R.image.tabbarCatalogue(),
                              highlightedIcon: R.image.tabbarCatalogue())
    }
}
