//
//  TabBarController.swift
//  KyivPost
//
//  Created by Mikhail Timoscenko on 22.06.2020.
//  Copyright © 2020 KyivPost. All rights reserved.
//

import Foundation
import UIKit

protocol TabBarControllerOutput: TabBarModelInput {}
protocol TabBarControllerInput: TabBarModelOutput {}

class TabBarController: UITabBarController {
    
    var model: TabBarControllerOutput!
    
    func configureTabs(with configuration: [(controller: UIViewController, tabItem: UITabBarItem)]) {
        let controllers = configuration.map { $0.controller }
        setViewControllers(controllers, animated: false)
        // We should set tabbarItems after setting controllers to allow changes to apply
        configuration.forEach { $0.controller.tabBarItem = $0.tabItem }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        model.controllerDidBecomeVisible()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        model.controllerDidBecomeHidden()
    }
    
}

extension TabBarController: TabBarControllerInput {
    
    func changeCurrentTab(_ tab: Tab) {
        selectedIndex = tab.rawValue
    }
    
}
