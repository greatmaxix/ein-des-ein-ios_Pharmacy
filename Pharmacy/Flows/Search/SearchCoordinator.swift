//
//  SearchCoordinator.swift
//  Pharmacy
//
//  Created by Anton Bal’ on 07.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import EventsTree

struct SearchFlowConfiguration {
    let parent: EventNode
}

final class SearchCoordinator: EventNode, Coordinator {
    
    private var root: UINavigationController!
    
    func createFlow() -> UIViewController {
        let viewController =  R.storyboard.search.instantiateInitialViewController()!
        let model = SearchModel(parent: self)
        viewController.model = model
        model.output = viewController
        root = NavigationController(rootViewController: viewController)
        
        return root
    }
    
    init(configuration: SearchFlowConfiguration) {
        super.init(parent: configuration.parent)
    
        addHandler { [weak self] (event: SearchModelEvent) in
            switch event {
            case .openList:
                self?.openMedicineList()
            case .open(let medicine):
                self?.open(medicine)
            case .openScan:
                self?.openScan()
            }
        }
    }
}

// MARK: - TabBarEmbedCoordinable

extension SearchCoordinator: TabBarEmbedCoordinable {
    var tabItemInfo: TabBarItemInfo {
        return TabBarItemInfo(title: "",
                              icon: R.image.tabbarSearch()?.withRenderingMode(.alwaysOriginal),
                              highlightedIcon: R.image.tabbarSearch()?.withRenderingMode(.alwaysOriginal))
    }
}

private extension SearchCoordinator {
    
    func openScan() {
        let vc = ScanCoordinator(configuration: .init(parent: self)).createFlow()
        root.pushViewController(vc, animated: true)
    }
    
    func openMedicineList() {
        let viewController = R.storyboard.catalogue.medicineListViewController()!
        let model = MedicineListModel(parent: self)
        viewController.model = model
        model.output = viewController
        root.pushViewController(viewController, animated: true)
    }
    
    func open(_ medicine: Medicine) {
        let viewController = ProductCoordinator(configuration: ProductFlowConfiguration(parent: self, navigation: root)).createFlowFor(product: medicine)
        root.pushViewController(viewController, animated: true)
    }
}
