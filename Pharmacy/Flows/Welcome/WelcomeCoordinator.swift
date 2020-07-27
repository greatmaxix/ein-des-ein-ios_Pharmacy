//
//  WelcomeCoordinator.swift
//  Pharmacy
//
//  Created by CGI-Kite on 27.07.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import EventsTree

struct WelcomeFlowConfiguration {
    
    let parent: EventNode
}

class WelcomeCoordinator: EventNode, Coordinator {
    
    private unowned var root: WelcomeViewController!
    private let storyboard: UIStoryboard = R.storyboard.welcome()
    
    init(configuration: WelcomeFlowConfiguration) {
        super.init(parent: configuration.parent)
        
    }
    
    func createFlow() -> UIViewController {
        
        // swiftlint:disable force_cast
        root = storyboard.instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController
        let model = WelcomeModel(parent: self)
        root.model = model
        
        let navigationVC: UINavigationController = UINavigationController(rootViewController: root)
        navigationVC.isToolbarHidden = true
        return navigationVC
    }
    
    private func popController() {
        root.navigationController?.popViewController(animated: true)
    }
}

// MARK: - TabBarEmbedCoordinable

extension WelcomeCoordinator: TabBarEmbedCoordinable {
    
    var tabItemInfo: TabBarItemInfo {
        return TabBarItemInfo(title: R.string.localize.tabbarMain(), icon: R.image.tabbarMain(), highlightedIcon: R.image.tabbarMain())
    }
}
