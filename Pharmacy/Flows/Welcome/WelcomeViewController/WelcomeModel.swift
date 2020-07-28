//
//  WelcomeModel.swift
//  Pharmacy
//
//  Created by CGI-Kite on 27.07.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import EventsTree

enum WelcomeEvent: Event {
    
    case openMap
    case openBarCodeReader
    case openCategories
}

protocol WelcomeModelOutput: class {
    
    func showReadyOrders(orders: [String])
}
protocol WelcomeModelInput: class {
    func loadReadyOrders()
}

final class WelcomeModel: EventNode {
    
    unowned var output: WelcomeModelOutput!
}

extension WelcomeModel: WelcomeModelInput {
    
    func loadReadyOrders() {
        let orders = ["34542", "90100"]
        output.showReadyOrders(orders: orders)
    }
}
