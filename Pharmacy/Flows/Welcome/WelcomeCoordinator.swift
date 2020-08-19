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

final class WelcomeCoordinator: EventNode, NaviagationEmbedCoordinable {
    
    lazy private(set) var navigationCoordinator: NavigationCoordinator = SearchNavigationCoordinator(configuration: .init(parent: self))
    
    private let storyboard: UIStoryboard = R.storyboard.welcome()
    
    init(configuration: WelcomeFlowConfiguration) {
      
        super.init(parent: configuration.parent)
        
        addHandler { [weak self] (event: WelcomeEvent) in
            switch event {
            case .openCategories(let categoryName):
                self?.openCategories(categoryName: categoryName)
            default:
                break
            }
        }
        
        addHandler { [weak self] (event: CatalogsEvent) in
            switch event {
            case .close:
                self?.popController()
            case .openMedicineListFor(let category):
                self?.openMedicineListFor(category: category)
            }
        }
        
        addHandler {  [weak self] (event: MedicineListModelEvent) in
            switch event {
            case .openProduct(let medicine):
                self?.openProductMedicineFor(medicine: medicine)
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
}

// MARK: - TabBarEmbedCoordinable

extension WelcomeCoordinator: TabBarEmbedCoordinable {
    
    var tabItemInfo: TabBarItemInfo {
        return TabBarItemInfo(title: R.string.localize.tabbarMain(),
                              icon: R.image.tabbarMain(),
                              highlightedIcon: R.image.tabbarMain())
    }
}

extension WelcomeCoordinator {
    fileprivate func popController() {
        navigation.popViewController(animated: true)
    }
    
    fileprivate func openCategories(categoryName: String) {
        let vc = R.storyboard.welcome.catalogsViewController()!
        let model = CatalogsModel(title: categoryName, parent: self)
        model.output = vc
        vc.model = model
        navigation.pushViewController(vc, animated: true)
    }
    
    fileprivate func openMedicineListFor(category: Category) {
        let vc = MedicineListCoordinator(configuration: .init(parent: self)).createFlow()
        navigation.pushViewController(vc, animated: true)
    }
    
    fileprivate func openProductMedicineFor(medicine: Medicine) {
        let vc = ProductCoordinator(configuration: .init(parent: self, navigation: navigation)).createFlowFor(product: medicine)
        navigation.pushViewController(vc, animated: true)
    }
}
