//
//  ReceiptsModel.swift
//  Pharmacy
//
//  Created by Mikhail Timoscenko on 12.11.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import EventsTree

enum ReceiptsModelEvent: Event {
    case close
}

protocol ReceiptsModelInput {
    var numberOfReceipts: Int { get }

    func initialLoad()
    func close()
    func receipt(at indexPath: IndexPath) -> UserReceipt
    func open(at indexPath: IndexPath)
}

protocol ReceiptsModelOutput: class {
    func complete(isEmpty: Bool, error: String?)
    func startLoading()
}

class ReceiptsModel: EventNode {

    private var apiList = DataManager<OrdersAPI, OrdersResponse>()

    private var page = 1
    private var perPage = 50

    weak var output: ReceiptsModelOutput!

    private var receipts: [UserReceipt] = []

    override init(parent: EventNode?) {
        super.init(parent: parent)

        receipts.append(
            contentsOf: [UserReceipt(id: 231231, text: "ГІДАЗЕПАМ IC® (GIDAZEPAM IC) 0,05 №10 табл. АТХ N05В А.", productURL: "", amount: 3, doctorURL: "", doctorName: "Иванчук О. А", isActive: true, activeTill: "02.12.2020"),
            UserReceipt(id: 123122, text: "ГІДАЗЕПАМ IC® (GIDAZEPAM IC) 0,05 №10 табл. АТХ N05В А.", productURL: "", amount: 1, doctorURL: "", doctorName: "Иванчук О. А", isActive: false, activeTill: "10.10.2020")]
        )
    }

    fileprivate func load() {

        output.startLoading()
    }
}

extension ReceiptsModel: ReceiptsModelInput, ReceiptsViewControllerOutput {

    var numberOfReceipts: Int {
        receipts.count
    }
    
    func initialLoad() {
        page = 1
    }

    func receipt(at indexPath: IndexPath) -> UserReceipt {
        return receipts[indexPath.row]
    }

    func open(at indexPath: IndexPath) {
        
    }

    func close() {
        raise(event: ReceiptsModelEvent.close)
    }
}
