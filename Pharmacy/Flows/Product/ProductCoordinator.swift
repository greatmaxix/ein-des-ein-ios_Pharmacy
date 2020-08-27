//
//  ProductCoordinator.swift
//  Pharmacy
//
//  Created by Anton Bal’ on 13.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import EventsTree

struct ProductFlowConfiguration {
    let parent: EventNode
    let navigation: UINavigationController
}

final class ProductCoordinator: EventNode, Coordinator {
    let navigation: UINavigationController
    
    func createFlow() -> UIViewController {
        fatalError()
    }
    
    func createFlowFor(product: Medicine) -> UIViewController {
        let root =  R.storyboard.product.instantiateInitialViewController()!
        let model = ProductModel(product: product, parent: self)
        root.model = model
        model.output = root
        return root
    }
    
    init(configuration: ProductFlowConfiguration) {
        navigation = configuration.navigation
        super.init(parent: configuration.parent)
        addHandler { [weak self] (event: ProductModelEvent) in
            switch event {
            case .openAnalogsFor, .openCatalogsFor:
                self?.openMedicineList()
            case .openMap(let product):
                self?.createMapFlow()
            }
        }
    }
}

extension ProductCoordinator {
    fileprivate func openMedicineList() {
        let vc = MedicineListCoordinator(configuration: .init(parent: self)).createFlow()
        navigation.pushViewController(vc, animated: true)
    }
    
    fileprivate func createMapFlow() {
        let vc = MapCoordinator(configuration: MapFlowConfiguration(parent: self)).createFlow()
        navigation.pushViewController(vc, animated: true)
    }
}
