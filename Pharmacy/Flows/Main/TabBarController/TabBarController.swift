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

final class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    var model: TabBarControllerOutput!
    
    func configureTabs(with configuration: [(controller: UIViewController, tabItem: UITabBarItem)]) {
        let controllers = configuration.map { $0.controller }
        setViewControllers(controllers, animated: false)
        // We should set tabbarItems after setting controllers to allow changes to apply
        configuration.forEach { $0.controller.tabBarItem = $0.tabItem }
        setupTabBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        model.controllerDidBecomeVisible()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        model.controllerDidBecomeHidden()
    }
    
   private func setupTabBar() {
        
        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()
        
        let cornerRadius: CGFloat = 30
        
        let roundedView: UIView = UIView()
        self.delegate = self
        
        roundedView.translatesAutoresizingMaskIntoConstraints = false
        roundedView.frame = CGRect(origin: .zero, size: CGSize(width: tabBar.frame.width, height: tabBar.frame.height * 2))
        roundedView.backgroundColor = .white
        roundedView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        roundedView.layer.cornerRadius = cornerRadius
        tabBar.addSubview(roundedView)
        tabBar.sendSubviewToBack(roundedView)
        
        let shadowLayer = CALayer()
        shadowLayer.frame = roundedView.frame
        shadowLayer.position = roundedView.layer.position
        shadowLayer.cornerRadius = cornerRadius
        shadowLayer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        let shadowPath = UIBezierPath(roundedRect: tabBar.bounds, cornerRadius: cornerRadius)

        shadowLayer.shadowPath = shadowPath.cgPath
        shadowLayer.backgroundColor = UIColor.white.cgColor
        
        shadowLayer.shadowColor = R.color.shadowBlue()?.withAlphaComponent(0.06).cgColor
        shadowLayer.shadowOpacity = 1
        shadowLayer.shadowRadius = 10
        shadowLayer.shadowOffset = CGSize(width: 0, height: -4)
        
        roundedView.layer.insertSublayer(shadowLayer, at: 0)
        
        NSLayoutConstraint.activate([
            roundedView.trailingAnchor.constraint(equalTo: tabBar.trailingAnchor),
            roundedView.leadingAnchor.constraint(equalTo: tabBar.leadingAnchor),
            roundedView.topAnchor.constraint(equalTo: tabBar.topAnchor),
            roundedView.bottomAnchor.constraint(equalTo: tabBar.bottomAnchor)
        ])
    }
}

extension TabBarController: TabBarControllerInput {
    
    func changeCurrentTab(_ tab: Tab) {
        self.selectedIndex = tab.rawValue
    }
}
