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
            case .openFarmacyList:
                self?.openMapFarmacyList()
            case .openCheckout:
                self?.openCheckout()
            }
        }
    }
}

fileprivate extension ProductCoordinator {
    
     func openMedicineList() {
        let vc = MedicineListCoordinator(configuration: .init(parent: self)).createFlow()
        navigation.pushViewController(vc, animated: true)
    }
    
     func createMapFlow() {
        guard let vc = R.storyboard.product.mapViewController() else { return }
        let model = MapModel(parent: self)
        model.output = vc
        vc.model = model
        navigation.pushViewController(vc, animated: true)
    }
    
    func openMapFarmacyList() {
        guard let vc = R.storyboard.product.mapFarmacyListViewController() else { return }
        let model = MapFarmacyListModel(parent: self)
        model.output = vc
        vc.model = model
        navigation.pushViewController(vc, animated: true)
    }
    
    func openCheckout() {
        guard let vc = R.storyboard.product.checkoutViewController() else { return }
        let model = CheckoutModel(parent: self)
        vc.model = model
        navigation.pushViewController(vc, animated: true)
    }
}
