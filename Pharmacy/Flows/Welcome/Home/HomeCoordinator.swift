//
//  HomeCoordinator.swift
//  Pharmacy
//
//  Created by Anton Bal’ on 08.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import EventsTree

struct HomeFlowConfiguration {
    let parent: EventNode
}

final class HomeCoordinator: EventNode, Coordinator {
    
    private let navigation: UINavigationController
    
    func createFlow() -> UIViewController {
        let root =  R.storyboard.home.instantiateInitialViewController()!
        let model = HomeModel(parent: self)
        root.model = model
        model.output = root
        root.title = "root"
        navigation.setViewControllers([root], animated: false)
        return navigation
    }
    
    init(configuration: HomeFlowConfiguration) {
        navigation = UINavigationController(navigationBarClass: HomeNavigationBar.self, toolbarClass: nil)
        super.init(parent: configuration.parent)
        
        addHandler { (event: HomeModelEvent) in
            
        }
    }
}

//MARK: - TabBarEmbedCoordinable

extension HomeCoordinator: TabBarEmbedCoordinable {
    var tabItemInfo: TabBarItemInfo {
        return TabBarItemInfo(title: R.string.localize.tabbarMain(),
                              icon: R.image.tabbarMain(),
                              highlightedIcon: R.image.tabbarMain())
    }
}
