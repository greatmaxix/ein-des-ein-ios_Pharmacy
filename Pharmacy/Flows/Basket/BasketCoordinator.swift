//
//  BasketCoordinator.swift
//  Pharmacy
//
//  Created by Anton Bal’ on 07.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import EventsTree

struct BasketFlowConfiguration {
    let parent: EventNode
}

final class BasketCoordinator: EventNode, Coordinator {

    var root: UINavigationController!
    
    func createFlow() -> UIViewController {
        let controller =  R.storyboard.basket.instantiateInitialViewController()!
        let model = BasketModel(parent: self)
        controller.model = model
        model.output = controller

        root = UINavigationController(rootViewController: controller)
        root.isNavigationBarHidden = true

        return root
    }
    
    init(configuration: BasketFlowConfiguration) {
        super.init(parent: configuration.parent)
        
        addHandler { [weak self] (event: BasketModelEvent) in
            switch event {
            case .create(let order):
                self?.presentOrder(with: order)
            }
        }

        addHandler { [weak self] (event: OrderDetailsEvent) in
            switch event {
            case .back:
                self?.showRoot()
            }
        }

        addHandler { [weak self] (event: CreateOrderModelEvent) in
            switch event {
            case .back:
                self?.pop()
            case .openOrder(let id):
                self?.openCreatedOrder(id: id)
            case .backToCart:
                self?.showRoot()
            }
        }
    }
}

// MARK: - TabBarEmbedCoordinable

extension BasketCoordinator: TabBarEmbedCoordinable {

    var tabItemInfo: TabBarItemInfo {
        return TabBarItemInfo(title: R.string.localize.tabbarBasket.localized(),
                              icon: R.image.tabbarShopping(),
                              highlightedIcon: R.image.tabbarShopping())
    }
}

extension BasketCoordinator {

    fileprivate func presentOrder(with order: PharmCartOrder) {

        if let controller: CreateOrderViewController = R.storyboard.basket().instantiateViewController(withIdentifier: "CreateOrderViewController") as? CreateOrderViewController {

            let model = CreateOrderModel(parent: self, order: order)
            controller.model = model
            model.output = controller
            root.pushViewController(controller, animated: true)
        }

    }

    fileprivate func showRoot() {
        root.popToRootViewController(animated: true)
    }

    fileprivate func openCreatedOrder(id: Int) {

        if let controller: OrderDetailsViewController = R.storyboard.orders().instantiateViewController(withIdentifier: "OrderDetailsViewController") as? OrderDetailsViewController {

            let model = OrderDetailsModel(parent: self, orderId: id, fromCart: true)
            controller.model = model
            model.output = controller
            root.pushViewController(controller, animated: true)
        }

    }

    fileprivate func pop() {
        root.popViewController(animated: true)
    }

}
