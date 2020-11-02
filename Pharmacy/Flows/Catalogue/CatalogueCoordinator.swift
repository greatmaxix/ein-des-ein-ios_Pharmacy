//
//  CatalogueCoordinator.swift
//  Pharmacy
//
//  Created by Anton Bal’ on 07.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import EventsTree

struct CatalogueFlowConfiguration {
    let parent: EventNode
}

final class CatalogueCoordinator: EventNode, Coordinator {

    var navigation: UINavigationController!
    
    // MARK: - Init / Deinit methods
    init(configuration: CatalogueFlowConfiguration) {
        super.init(parent: configuration.parent)

        addHandler(.onPropagate) { [weak self] (event: WelcomeEvent) in
            switch event {
            case .openCategories(let category):
                if let c = category {
                    self?.openCategories(category: c)
                } else {
                    self?.popToRootController()
                }
            default:
                break
            }
        }

        addHandler(.onRaise) { [weak self] (event: CatalogueEvent) in
            switch event {
            case .close:
                self?.popController()
            case .openMedicineListFor(let category):
                self?.openMedicineListFor(category: category)
            }
        }

        addHandler(.onRaise) {  [weak self] (event: MedicineListModelEvent) in
            switch event {
            case .openProduct(let medicine):
                self?.openProductMedicineFor(medicine: medicine)
            }
        }

        addHandler { (_: BasketModelEvent) in

        }
    }

    // MARK: - Public methods
    func createFlow() -> UIViewController {
        let viewController = R.storyboard.catalogue.instantiateInitialViewController()!
        let model = CatalogueModel(parent: self)
        viewController.model = model
        model.output = viewController
        let nav = NavigationController(rootViewController: viewController)
        navigation = nav
        return nav
    }
}

// MARK: - Private methods
extension CatalogueCoordinator {

    private func openCategories(category: Category?) {
        let viewController = R.storyboard.catalogue.subcategoryViewController()!
        let model = SubcategoryModel(category: category, parent: self)
        model.output = viewController
        viewController.model = model
        navigation.pushViewController(viewController, animated: true)
    }

    private func popController() {
        navigation.popViewController(animated: true)
    }
    
    private func popToRootController() {
        navigation.popToRootViewController(animated: true)
    }

    private func openMedicineListFor(category: Category) {
        let viewController = R.storyboard.catalogue.medicineListViewController()!
        let model = MedicineListModel(category: category, parent: self)
        viewController.model = model
        model.output = viewController
        navigation.pushViewController(viewController, animated: true)
    }

    private func openProductMedicineFor(medicine: Medicine) {
        let vc = ProductCoordinator(configuration: .init(parent: self, navigation: navigation)).createFlowFor(product: medicine)
        navigation.pushViewController(vc, animated: true)
    }
}

// MARK: - TabBarEmbedCoordinable
extension CatalogueCoordinator: TabBarEmbedCoordinable {
    var tabItemInfo: TabBarItemInfo {
        return TabBarItemInfo(title: R.string.localize.tabbarCatalogue(),
                              icon: R.image.tabbarCatalogue(),
                              highlightedIcon: R.image.tabbarCatalogue())
    }
}
