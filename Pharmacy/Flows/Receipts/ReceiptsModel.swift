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

    private var apiList = DataManager<ReceiptsAPI, UserReceiptsResponse>()

    private var page = 1
    private var perPage = 50

    weak var output: ReceiptsModelOutput!

    private var receipts: [UserReceipt] = []

    override init(parent: EventNode?) {
        super.init(parent: parent)
    }

    fileprivate func load() {

        apiList.load(target: .loadReceipts,
                     completion: { [weak self] result in
                        guard let `self` = self else { return }

                        switch result {
                        case .success(let response):
                            self.receipts = response.items
                            self.output.complete(isEmpty: self.receipts.isEmpty, error: nil)
                        case .failure(let error):
                            return
                            self.output.complete(isEmpty: self.receipts.isEmpty, error: error.localizedDescription)
                        }
                     })

        output.startLoading()
    }
}

extension ReceiptsModel: ReceiptsModelInput, ReceiptsViewControllerOutput {

    var numberOfReceipts: Int {
        receipts.count
    }
    
    func initialLoad() {
        page = 1
        load()
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
