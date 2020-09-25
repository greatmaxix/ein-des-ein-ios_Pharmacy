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
            
            guard let self = self else { return }
            
            switch event {
            case .openAnalogsFor, .openCatalogsFor:
                self.openMedicineList()
            case .openMap(let product):
                // TODO: Replace product by medicine after adding detail medicine request
                self.createMapFlow(medicineId: product.id)
            case .openFarmacyList(let pharmacies):
                self.openMapFarmacyList(pharmacies: pharmacies)
            case .openCheckout:
                self.openCheckout()
            }
        }
    }
}

fileprivate extension ProductCoordinator {
    
     func openMedicineList() {
        let vc = MedicineListCoordinator(configuration: .init(parent: self)).createFlow()
        navigation.pushViewController(vc, animated: true)
    }
    
    func createMapFlow(medicineId: Int) {
        guard let vc = R.storyboard.product.mapViewController() else { return }
        let model = MapModel(parent: self, medicineId: medicineId)
        model.output = vc
        vc.model = model
        navigation.pushViewController(vc, animated: true)
    }
    
    func openMapFarmacyList(pharmacies: [PharmacyModel]) {
        guard let vc = R.storyboard.product.mapFarmacyListViewController() else { return }
        let model = MapFarmacyListModel(parent: self, pharmacies: pharmacies)
        model.output = vc
        vc.model = model
        navigation.pushViewController(vc, animated: true)
    }
    
    func openCheckout() {
        guard let vc = R.storyboard.product.checkoutViewController() else { return }
        let model = CheckoutModel(parent: self)
        vc.model = model
        model.output = vc
        navigation.pushViewController(vc, animated: true)
    }
}
