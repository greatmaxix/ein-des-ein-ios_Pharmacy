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

    

}

protocol CreateOrderModelOutput: class {

}

final class CreateOrderModel: Model {

    weak var output: CreateOrderModelOutput!

    private var order: PharmCartOrder!

    init(parent: EventNode?, order: PharmCartOrder) {
        super.init(parent: parent)

        self.order = order
    }

}

// MARK: - BasketViewControllerOutput

extension CreateOrderModel: CreateOrderViewControllerOutput {

}
