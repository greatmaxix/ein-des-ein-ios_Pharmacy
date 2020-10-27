//
//  MainFlowCoordinator.swift
//  KyivPost
//
//  Created by Mikhail Timoscenko on 22.06.2020.
//  Copyright © 2020 KyivPost. All rights reserved.
//

import UIKit
import EventsTree

class TabBarCoordinator: EventNode, Coordinator {
    
    private weak var root: TabBarController!
  
    init() {
        super.init(parent: )

        addHandler { [weak self] (event: AppEvent) in
            switch event {
            case .presentInDev:
                self?.presentInDev()
            }
        }
    }
  
    func createFlow() -> UIViewController {
        let tabBarController = TabBarController()
        let model = TabBarModel(parent: self)
        
        tabBarController.model = model
        model.output = tabBarController
        root = tabBarController

        setupTabBar()
        
        return tabBarController
    }
  
    private func presentInDev() {
        guard let inDevVC: InDevelopmentViewController = R.storyboard.inDevelopment.inDevelopmentViewController() else {
            return
        }
        
        root.navigationController?.pushViewController(inDevVC, animated: true)
    }

    private func addTabCoordinators(coordinators: [TabBarEmbedCoordinable]) {
        var controllers: [UIViewController] = []
        var tabItemMap: [(controller: UIViewController, tabItem: UITabBarItem)] = []
        for coordinator in coordinators {
            let controller = coordinator.createFlow()
            let tabItem = coordinator.tabItem()
            tabItemMap.append((controller: controller, tabItem: tabItem))
            controllers.append(controller)
        }

        root.configureTabs(with: tabItemMap)
    }
    
    private func setupTabBar() {
        var coordinators: [TabBarEmbedCoordinable] = []
        let welcomeConfig = WelcomeFlowConfiguration(parent: self)
        coordinators.append(WelcomeCoordinator(configuration: welcomeConfig))
        
        let catalogueConfig = CatalogueFlowConfiguration(parent: self)
        coordinators.append(CatalogueCoordinator(configuration: catalogueConfig))
        
        let serachConfig = SearchFlowConfiguration(parent: self)
        coordinators.append(SearchCoordinator(configuration: serachConfig))
        
        let basketConfig = BasketFlowConfiguration(parent: self)
        coordinators.append(BasketCoordinator(configuration: basketConfig))
        
        let config = ProfileFlowConfiguration(parent: self)
        coordinators.append(ProfileFlowCoordinator(configuration: config))
        
        addTabCoordinators(coordinators: coordinators)
    }
}
