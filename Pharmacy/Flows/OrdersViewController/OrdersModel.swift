//
//  OrdersModel.swift
//  Pharmacy
//
//  Created by CGI-Kite on 20.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit
import EventsTree

protocol OrdersListInput {
    func close()
    func initialLoad()
}

protocol OrdersListOutput: class {
    func complete(isEmpty: Bool, error: String?)
}

enum OrderListRequestState {
    case all
    case canceled
    case processing
    case done

    func toString() -> String? {
        switch self {
        case .all:
            return nil
        case .canceled:
            return "canceled"
        case .processing:
            return "in_progress"
        case .done:
            return "done"
        }
    }
}

class OrdersListModel: EventNode {

    private var apiList = DataManager<OrdersAPI, OrdersResponse>()

    private var page = 1
    private var perPage = 50

    weak var output: OrdersListOutput!

    private var orders: [Order] = []
    private var currentState: OrderListRequestState = .all

    fileprivate func loadNext() {

        apiList.load(target: .getOrders(
                        page: page,
                        count: perPage,
                        status: currentState.toString()),
                     completion: { [weak self] result in
                        guard let self = self else { return }

                        switch result {
                        case .success(let response):
                            self.orders = response.items
                            self.output.complete(isEmpty: self.orders.isEmpty, error: nil)
                        case .failure(let error):
                            self.output.complete(isEmpty: self.orders.isEmpty, error: error.localizedDescription)
                        }
                     })

    }
}

extension OrdersListModel: OrdersListInput, OrdersViewControllerOutput {
    
    func close() {
        raise(event: ProfileEvent.close)
    }

    func initialLoad() {
        page = 1
        loadNext()
    }
}
