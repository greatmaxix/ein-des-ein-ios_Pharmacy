//
//  CreateOrderModel.swift
//  Pharmacy
//
//  Created by Mikhail Timoscenko on 29.10.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import EventsTree

enum CreateOrderModelEvent: Event { }

protocol CreateOrderModelInput: class {

    var numberOfRows: Int { get }

    func type(at indexPath: IndexPath) -> CreateOrderCellType

}

protocol CreateOrderModelOutput: class {

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

final class CreateOrderModel: Model {

    weak var output: CreateOrderModelOutput!

    private var order: PharmCartOrder!
    private var cellTypes: [CreateOrderCellType]!

    init(parent: EventNode?, order: PharmCartOrder) {
        super.init(parent: parent)

        self.order = order

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

    func type(at indexPath: IndexPath) -> CreateOrderCellType {
        return cellTypes[indexPath.row]
    }

}
