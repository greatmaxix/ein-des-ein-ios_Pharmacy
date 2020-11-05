//
//  CreateOrderModel.swift
//  Pharmacy
//
//  Created by Mikhail Timoscenko on 29.10.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import EventsTree

enum CreateOrderModelEvent: Event {
    case back
    case openOrder(id: Int)
    case backToCart
}

protocol CreateOrderModelInput: class {

    var numberOfRows: Int { get }
    var currentOrder: PharmCartOrder { get }
    var isValid: Bool { get }
    var contact: OrderContactInfo? { get }
    var address: OrderDeliveryAddress? { get }

    func product(at indexPath: IndexPath) -> CartMedicine
    func type(at indexPath: IndexPath) -> CreateOrderCellType
    func changeDelivery(type: DeliveryType)
    func back()
    func createOrder()
    func update(comment: String)
}

protocol CreateOrderModelOutput: class {

    func reload()
    func setAddress(hidden: Bool, at index: Int)
    func networkEnded(with error: String?)
}

enum CreateOrderCellType: Int {

    case contactInfo
    case delivery
    case pharmacy
    case deliveryAddress
    case paymentType
    case product
    case comments
    case total

}

enum DeliveryType {
    case selfdelivery
    case ordered

    func toString() -> String {
        switch self {
        case .ordered:
            return "delivery_address"
        case .selfdelivery:
            return "pickup"
        }
    }
}

final class CreateOrderModel: Model {

    weak var output: CreateOrderModelOutput!

    private var order: PharmCartOrder!
    private var cellTypes: [CreateOrderCellType]!
    private var deliveryType: DeliveryType = .ordered
    private var orderContactInfo: OrderContactInfo?
    private var deliveryAddress: OrderDeliveryAddress?
    private var comment: String = ""

    private var api = DataManager<OrdersAPI, OrderDetailsResponse>()

    init(parent: EventNode?, order: PharmCartOrder) {
        super.init(parent: parent)

        self.order = order

        createCells()

        deliveryAddress = OrderDeliveryAddress(city: nil, street: nil, house: nil, appartment: nil)

        guard let user = UserSession.shared.user else { return }

        orderContactInfo = OrderContactInfo(name: user.name, phone: user.phone, email: user.email)
    }

    fileprivate func createCells() {
        cellTypes = [.contactInfo, .delivery, .pharmacy, .deliveryAddress, .paymentType]
        cellTypes.append(contentsOf: [CreateOrderCellType].init(repeating: .product, count: order.products.count))
        cellTypes.append(contentsOf: [.comments, .total])
    }
}

// MARK: - BasketViewControllerOutput

extension CreateOrderModel: CreateOrderViewControllerOutput {

    var numberOfRows: Int {
        cellTypes.count
    }

    var currentOrder: PharmCartOrder {
        order
    }

    var isValid: Bool {
        return false
    }

    var contact: OrderContactInfo? {
        orderContactInfo
    }

    var address: OrderDeliveryAddress? {
        deliveryAddress
    }

    func product(at indexPath: IndexPath) -> CartMedicine {
        let delta = deliveryType == .ordered ? 5 : 4
        return order.products[indexPath.row - delta]
    }

    func changeDelivery(type: DeliveryType) {

        if deliveryType == type {
            return
        }

        deliveryType = type

        if deliveryType == .selfdelivery {
            cellTypes.remove(at: 3)
            output.setAddress(hidden: true, at: 3)
        } else {
            cellTypes.insert(.deliveryAddress, at: 3)
            output.setAddress(hidden: false, at: 3)
        }
    }

    func createOrder() {
        guard let contact = orderContactInfo, let address = deliveryAddress else {
            output.networkEnded(with: nil)
            return
        }

        if contact.name.isEmpty || contact.phone.isEmpty {
            output.networkEnded(with: "Контакты не заполнены")
            return
        }

        if deliveryType == .ordered {
            if address.city == nil || address.street == nil || address.house == nil {
                output.networkEnded(with: "Адресс доставки не указан")
                return
            }
        }

        api.load(target: .createOrderWith(
                    order: order,
                    contact: contact,
                    address: address,
                    paymentType: "cash",
                    deliveryType: deliveryType.toString(),
                    comment: comment), completion: { [weak self] result in
                        guard let `self` = self else { return }

                        switch result {
                        case .success(let response):
                            guard let id = response.item.orderId else {
                                self.output.networkEnded(with: nil)
                                return
                            }
                            self.raise(event: CreateOrderModelEvent.openOrder(id: id))
                            self.output.networkEnded(with: nil)
                        case .failure(let error):
                            self.output.networkEnded(with: error.localizedDescription)
                        }
                    })
    }

    func type(at indexPath: IndexPath) -> CreateOrderCellType {
        return cellTypes[indexPath.row]
    }

    func update(comment: String) {
        self.comment = comment
    }

    func back() {
        raise(event: CreateOrderModelEvent.back)
    }

}
