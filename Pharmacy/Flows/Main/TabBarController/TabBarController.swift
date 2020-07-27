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
        
        setupTabBar()
        model.controllerDidBecomeVisible()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        model.controllerDidBecomeHidden()
    }
    
    func setupTabBar() {
        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()
        
        let roundedView: UIView = UIView()
        roundedView.frame = CGRect(origin: .zero, size: CGSize(width: tabBar.frame.width, height: tabBar.frame.height * 2))
        roundedView.backgroundColor = .white
        roundedView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        roundedView.layer.cornerRadius = 30
        tabBar.addSubview(roundedView)
        tabBar.sendSubviewToBack(roundedView)
        
        let shadowLayer = CALayer()
        shadowLayer.frame = roundedView.frame
        shadowLayer.position = roundedView.layer.position
        
        shadowLayer.cornerRadius = 30
        shadowLayer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        let shadowPath = UIBezierPath(roundedRect: tabBar.bounds, cornerRadius: 30)

        shadowLayer.shadowPath = shadowPath.cgPath
        shadowLayer.backgroundColor = UIColor.white.cgColor
        
        shadowLayer.shadowColor = UIColor(red: 0, green: 0.145, blue: 0.918, alpha: 0.06).cgColor
        shadowLayer.shadowOpacity = 1
        shadowLayer.shadowRadius = 10
        shadowLayer.shadowOffset = CGSize(width: 0, height: -4)
        
        roundedView.layer.insertSublayer(shadowLayer, at: 0)
    }
}

extension TabBarController: TabBarControllerInput {
    
    func changeCurrentTab(_ tab: Tab) {
        selectedIndex = tab.rawValue
    }
    
}
