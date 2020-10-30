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
}

protocol CreateOrderModelInput: class {

    var numberOfRows: Int { get }
    var currentOrder: PharmCartOrder { get }
    var isValid: Bool { get }

    func product(at indexPath: IndexPath) -> CartMedicine
    func type(at indexPath: IndexPath) -> CreateOrderCellType
    func changeDelivery(type: DeliveryType)
    func back()

}

protocol CreateOrderModelOutput: class {

    func reload()
    func setAddress(hidden: Bool, at index: Int)
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
}

final class CreateOrderModel: Model {

    weak var output: CreateOrderModelOutput!

    private var order: PharmCartOrder!
    private var cellTypes: [CreateOrderCellType]!
    private var deliveryType: DeliveryType = .ordered

    init(parent: EventNode?, order: PharmCartOrder) {
        super.init(parent: parent)

        self.order = order

        createCells()
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

    func product(at indexPath: IndexPath) -> CartMedicine {
        let delta = deliveryType == .ordered ? 5 : 4
        return order.products[indexPath.row - delta]
    }

    func changeDelivery(type: DeliveryType) {
        deliveryType = type

        if deliveryType == .selfdelivery {
            cellTypes.remove(at: 3)
            output.setAddress(hidden: true, at: 3)
        } else {
            cellTypes.insert(.deliveryAddress, at: 3)
            output.setAddress(hidden: false, at: 3)
        }
    }

    func type(at indexPath: IndexPath) -> CreateOrderCellType {
        return cellTypes[indexPath.row]
    }

    func back() {
        raise(event: CreateOrderModelEvent.back)
    }

}
