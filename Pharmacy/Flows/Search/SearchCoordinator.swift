//
//  SearchCoordinator.swift
//  Pharmacy
//
//  Created by Anton Bal’ on 07.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import EventsTree

struct SearchFlowConfiguration {
    let parent: EventNode
}

final class SearchCoordinator: EventNode, Coordinator {
    
    func createFlow() -> UIViewController {
        let root =  R.storyboard.search.instantiateInitialViewController()!
        let model = SearchModel(parent: self)
        root.model = model
        model.output = root
        return root
    }
    
    init(configuration: SearchFlowConfiguration) {
        super.init(parent: configuration.parent)
        
        addHandler { (event: SearchModelEvent) in
            
        }
    }
}

//MARK: - TabBarEmbedCoordinable

extension SearchCoordinator: TabBarEmbedCoordinable {
    var tabItemInfo: TabBarItemInfo {
        return TabBarItemInfo(title: "",
                              icon: R.image.tabbarSearch()?.withRenderingMode(.alwaysOriginal),
                              highlightedIcon: R.image.tabbarSearch()?.withRenderingMode(.alwaysOriginal))
    }
}
