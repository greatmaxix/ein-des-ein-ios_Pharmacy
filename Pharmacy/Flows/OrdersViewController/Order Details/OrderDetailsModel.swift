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

    func load()
    func back()
}

protocol OrderDetailsModelOutput: class {

}

class OrderDetailsModel: EventNode {

    private var api = DataManager<OrdersAPI, OrderDetailsResponse>()
    weak var output: OrderDetailsModelOutput!

    private var orderId: Int = 0

    init(parent: EventNode?, orderId: Int) {
        super.init(parent: parent)

        self.orderId = orderId
    }

}

extension OrderDetailsModel: OrderDetailsModelInput, OrderDetailsViewControllerOutput {

    var currentOrderId: String {
        "\(orderId)"
    }

    func load() {
        api.load(target: .orderDteails(orderId: orderId),
                     completion: { [weak self] result in
                        guard let self = self else { return }

                        switch result {
                        case .success(let response):
                            return
//                            self.orders = response.items
//                            self.output.complete(isEmpty: self.orders.isEmpty, error: nil)
                        case .failure(let error):
                            return
//                            self.output.complete(isEmpty: self.orders.isEmpty, error: error.localizedDescription)
                        }
                     })
    }

    func back() {
        raise(event: OrderDetailsEvent.back)
    }

}
