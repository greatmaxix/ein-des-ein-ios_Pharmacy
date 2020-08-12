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
    case openCategories(categoryName: String)
}

protocol WelcomeModelOutput: class {
    func showReadyOrders(orders: [String])
    func showReceipts(_ receipts: [Receipt])
}
protocol WelcomeModelInput: class {
    func load()
    func openCategories()
}

final class WelcomeModel: EventNode {
    
    unowned var output: WelcomeModelOutput!
}

extension WelcomeModel: WelcomeModelInput {
    func load() {
        loadReadyOrders()
        loadReceipts()
    }
    
    private func loadReadyOrders() {
        let orders = ["34542", "90100"]
        output.showReadyOrders(orders: orders)
    }
    
    private func loadReceipts() {
        let receipts = [Receipt(title: "Название товара",
                                subtitle: "Таблетки шипучие, 20 мг", imageURL: nil, price: "568₽"),
                        Receipt(title: "Название товара",
                                subtitle: "Таблетки шипучие, 20 мг", imageURL: nil, price: "568₽")]
        
        output.showReceipts(receipts)
    }
    
    func openCategories() {
        raise(event: WelcomeEvent.openCategories(categoryName: "category1"))
    }
}
