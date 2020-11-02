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

    func load()
    func back()
    func type(at indexPath: IndexPath) -> CreateOrderCellType
}

protocol OrderDetailsModelOutput: class {
    func didLoadData(error: String?)
}

class OrderDetailsModel: EventNode {

    private var api = DataManager<OrdersAPI, OrderDetailsResponse>()
    weak var output: OrderDetailsModelOutput!

    private var orderId: Int = 0
    private var order: OrderDetails!
    private var cellTypes: [CreateOrderCellType]!

    init(parent: EventNode?, orderId: Int) {
        super.init(parent: parent)

        self.orderId = orderId
        createCells()
    }

    fileprivate func createCells() {
        cellTypes = [.contactInfo] //, .pharmacy, .deliveryAddress, .paymentType]
//        cellTypes.append(contentsOf: [CreateOrderCellType].init(repeating: .product, count: order.products.count))
//        cellTypes.append(contentsOf: [.comments, .total])
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

    var contact: DetailedOrderContact? {
        order.contactInfo
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

    func back() {
        raise(event: OrderDetailsEvent.back)
    }

    func type(at indexPath: IndexPath) -> CreateOrderCellType {
        return cellTypes[indexPath.row]
    }

}
