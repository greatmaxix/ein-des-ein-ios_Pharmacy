//
//  OrderDetailsModel.swift
//  Pharmacy
//
//  Created by Mikhail Timoscenko on 02.11.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import EventsTree

enum OrderDetailsEvent: Event {
    case back
}

protocol OrderDetailsModelInput {
    var currentOrderId: String { get }
    var numberOfRows: Int { get }
    var contact: DetailedOrderContact? { get }
    var pharmacy: PharmacyOrder? { get }
    var delivery: OrderDetailsDelivery? { get }
    var comment: String? { get }
    var cost: Decimal { get }

    func load()
    func back()
    func cancelOrder()
    func type(at indexPath: IndexPath) -> CreateOrderCellType
    func product(at indexPath: IndexPath) -> CartMedicine?
}

protocol OrderDetailsModelOutput: class {
    func didLoadData(error: String?)
}

class OrderDetailsModel: EventNode {

    private var api = DataManager<OrdersAPI, OrderDetailsResponse>()
    weak var output: OrderDetailsModelOutput!

    private var orderId: Int = 0
    private var order: OrderDetails! {
        didSet {
            createCells()
        }
    }
    private var cellTypes: [CreateOrderCellType]!
    private var fromCart: Bool = false

    init(parent: EventNode?, orderId: Int, fromCart: Bool = false) {
        super.init(parent: parent)

        self.orderId = orderId
        self.fromCart = fromCart
    }

    fileprivate func createCells() {
        cellTypes = [.contactInfo, .pharmacy]

        if order.deliveryInfo?.type == "delivery_address" {
            cellTypes.append(.deliveryAddress)
        }

        cellTypes.append(.paymentType)

        if let products = order.products {
            cellTypes.append(contentsOf: [CreateOrderCellType].init(repeating: .product, count: products.count))
        }

        if order.deliveryInfo?.comment != nil {
            cellTypes.append(.comments)
        }

        cellTypes.append(.total)
    }

}

extension OrderDetailsModel: OrderDetailsModelInput, OrderDetailsViewControllerOutput {

    var currentOrderId: String {
        "\(orderId)"
    }

    var numberOfRows: Int {
        if order == nil {
            return 0
        } else {
            return cellTypes.count
        }
    }

    var comment: String? {
        order.deliveryInfo?.comment
    }

    var contact: DetailedOrderContact? {
        order.contactInfo
    }

    var pharmacy: PharmacyOrder? {
        order.pharmacy
    }

    var delivery: OrderDetailsDelivery? {
        order.deliveryInfo
    }

    var cost: Decimal {
        order.totalCost ?? 0
    }

    func load() {
        api.load(target: .orderDteails(orderId: orderId),
                     completion: { [weak self] result in
                        guard let `self` = self else { return }

                        switch result {
                        case .success(let response):
                            self.order = response.item
                            self.output.didLoadData(error: nil)
                        case .failure(let error):
                            self.output.didLoadData(error: error.localizedDescription)
                        }
                     })
    }

    func product(at indexPath: IndexPath) -> CartMedicine? {
        let delta = order.deliveryInfo?.type == "delivery_address" ? 4 : 3
        return order.products?[indexPath.row - delta]
    }

    func back() {
        if fromCart == true {
            raise(event: CreateOrderModelEvent.backToCart)
        } else {
            raise(event: OrderDetailsEvent.back)
        }
    }

    func type(at indexPath: IndexPath) -> CreateOrderCellType {
        return cellTypes[indexPath.row]
    }

    func cancelOrder() {
        
    }
}
