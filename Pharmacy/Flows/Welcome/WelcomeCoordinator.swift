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
        
        addHandler(.onRaise) { [weak self] (event: WelcomeEvent) in
            switch event {
            case .openCategories(let category):
                self?.openCategories(category: category)
            default:
                break
            }
        }
        
        addHandler(.onRaise) { [weak self] (event: CatalogsEvent) in
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
    
    fileprivate func openCategories(category: Category?) {
        let vc = R.storyboard.catalogue.catalogueViewController()!
        let model = CatalogueModel(category: category, parent: self)
        model.output = vc
        vc.model = model
        navigation.pushViewController(vc, animated: true)
    }
    
    fileprivate func openMedicineListFor(category: Category) {
        let viewController = R.storyboard.catalogue.medicineListViewController()!
        let model = MedicineListModel(parent: self)
        viewController.model = model
        model.output = viewController
        navigation.pushViewController(viewController, animated: true)
    }
    
    fileprivate func openProductMedicineFor(medicine: Medicine) {
        let vc = ProductCoordinator(configuration: .init(parent: self, navigation: navigation)).createFlowFor(product: medicine)
        navigation.pushViewController(vc, animated: true)
    }
}
