//
//  OrdersModel.swift
//  Pharmacy
//
//  Created by CGI-Kite on 20.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit
import EventsTree

enum OrdersListEvent: Event {
    case openOrder(id: Int)
}

protocol OrdersListInput {
    var numberOfOrders: Int { get }

    func close()
    func initialLoad()
    func open(tab: OrderListRequestState)
    func order(at indexPath: IndexPath) -> Order
    func open(at indexPath: IndexPath)
    func startSearch()
}

protocol OrdersListOutput: class {
    func complete(isEmpty: Bool, error: String?)
    func startLoading()
}

enum OrderListRequestState: String {
    case all = "all"
    case canceled = "canceled"
    case inProgress = "in_progress"
    case done = "done"
    case new = "new"
    case ready = "ready"
    case toDelivery = "to_delivery"
    case inDelivery = "in_delivery"

    func color() -> UIColor? {
        switch self {
        case .new:
            return R.color.welcomeBlue()
        case .inProgress:
            return R.color.orange()
        case .ready:
            return .yellow
        case .done:
            return R.color.welcomeGreen()
        case .canceled:
            return .red
        default:
            return R.color.welcomeBlue()
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

    fileprivate func load() {

        output.startLoading()

        let state = (currentState == .all) ? nil : currentState.rawValue

        apiList.load(target: .getOrders(
                        page: page,
                        count: perPage,
                        status: state),
                     completion: { [weak self] result in
                        guard let `self` = self else { return }

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
    func startSearch() {
        raise(event: AppEvent.presentInDev)
    }
    
    var numberOfOrders: Int {
        orders.count
    }

    func close() {
        raise(event: ProfileEvent.close)
    }

    func initialLoad() {
        page = 1
        load()
    }

    func open(tab: OrderListRequestState) {
        if currentState == tab { return }

        currentState = tab
        orders.removeAll()

        load()
    }

    func order(at indexPath: IndexPath) -> Order {
        return orders[indexPath.row]
    }

    func open(at indexPath: IndexPath) {
        guard let id = order(at: indexPath).orderId else { return }

        raise(event: OrdersListEvent.openOrder(id: id))
    }
}
