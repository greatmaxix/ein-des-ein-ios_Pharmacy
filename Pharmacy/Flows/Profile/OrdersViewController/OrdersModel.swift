//
//  OrdersModel.swift
//  Pharmacy
//
//  Created by CGI-Kite on 20.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit
import EventsTree

protocol OrdersInput {
    func close()
}

final class OrdersModel: EventNode {
    
}

extension OrdersModel: OrdersInput {
    
    func close() {
        raise(event: ProfileEvent.close)
    }
}
