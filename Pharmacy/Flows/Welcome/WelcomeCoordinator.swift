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

final class WelcomeCoordinator: EventNode {
    
    private let storyboard: UIStoryboard = R.storyboard.welcome()
    
    let navigation: UINavigationController
    
    init(configuration: WelcomeFlowConfiguration) {
        navigation = UINavigationController(navigationBarClass: NavigationBar.self, toolbarClass: nil)
        
        super.init(parent: configuration.parent)
        
        addHandler { [weak self] (event: WelcomeEvent) in
            switch event {
            case .openCategories(let categoryName):
                self?.presentCategories(categoryName: categoryName)
            default:
                break
            }
        }
        
        addHandler { [weak self] (event: CatalogsEvent) in
            switch event {
            case .close:
                self?.popController()
            default:
                break
            }
        }
    }
    
    func createFlow() -> UIViewController {
        let root = R.storyboard.welcome.instantiateInitialViewController()!
        let model = WelcomeModel(parent: self)
        model.output = root
        root.model = model
    
        navigation.isToolbarHidden = true
        navigation.setViewControllers([root], animated: false)
        return navigation
    }
    
    private func popController() {
        navigation.popViewController(animated: true)
    }
    
    private func presentCategories(categoryName: String) {
        guard let vc: CatalogsViewController = storyboard.instantiateViewController(withIdentifier: "CatalogsViewController") as? CatalogsViewController else {
            return
        }
        
        let model = CatalogsModel(parent: self)
        model.setup(title: categoryName)
        model.output = vc
        vc.model = model
        navigation.pushViewController(vc, animated: true)
    }
}

// MARK: - TabBarEmbedCoordinable

extension WelcomeCoordinator: TabBarEmbedCoordinable {
    
    var tabItemInfo: TabBarItemInfo {
        return TabBarItemInfo(title: R.string.localize.tabbarMain(),
                              icon: R.image.tabbarMain(),
                              highlightedIcon: R.image.tabbarMain())
    }
}
