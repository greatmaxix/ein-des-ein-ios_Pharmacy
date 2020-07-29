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
        
        // swiftlint:disable force_cast
        root = storyboard.instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController
        let model = WelcomeModel(parent: self)
        model.output = root
        root.model = model
        
        let navigationVC: UINavigationController = UINavigationController(rootViewController: root)
        navigationVC.isToolbarHidden = true
        return navigationVC
    }
    
    private func popController() {
        root.navigationController?.popViewController(animated: true)
    }
    
    private func presentCategories(categoryName: String) {
        guard let vc: CatalogsViewController = storyboard.instantiateViewController(withIdentifier: "CatalogsViewController") as? CatalogsViewController else {
            return
        }
        
        let model = CatalogsModel(parent: self)
        model.setup(title: categoryName)
        model.output = vc
        vc.model = model
        root.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - TabBarEmbedCoordinable

extension WelcomeCoordinator: TabBarEmbedCoordinable {
    
    var tabItemInfo: TabBarItemInfo {
        return TabBarItemInfo(title: R.string.localize.tabbarMain(), icon: R.image.tabbarMain(), highlightedIcon: R.image.tabbarMain())
    }
}
