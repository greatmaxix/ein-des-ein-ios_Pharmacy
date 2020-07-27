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
    
    func createFlow() -> UIViewController {
        let tabBarController = TabBarController()
        let model = TabBarModel(parent: self)
        
        tabBarController.model = model
        model.output = tabBarController
        root = tabBarController

        setupTabBar()
        
        return tabBarController
    }

    func addTabCoordinators(coordinators: [TabBarEmbedCoordinable]) {
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
        let config = ProfileFlowConfiguration(parent: self)
        coordinators.append(ProfileFlowCoordinator(configuration: config))
        addTabCoordinators(coordinators: coordinators)
        
        let welcomeConfig: WelcomeFlowConfiguration = WelcomeFlowConfiguration(parent: self)
        coordinators.append(WelcomeCoordinator(configuration: welcomeConfig))
        addTabCoordinators(coordinators: coordinators)
    }
    
}
