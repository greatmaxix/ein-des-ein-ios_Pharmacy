//
//  BasketModel.swift
//  Pharmacy
//
//  Created by Anton Bal’ on 07.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import EventsTree

enum BasketModelEvent: Event { }

protocol BasketModelInput: class {
    func load()
}

protocol BasketModelOutput: class {}

final class BasketModel: Model {
    
    weak var output: BasketModelOutput!

    private var loader = DataManager<ProductCartAPI, CartResponse>()

    private var cartOrders: [PharmCartOrder] = []
    
}

// MARK: - BasketViewControllerOutput

extension BasketModel: BasketViewControllerOutput {

    func load() {
        loader.load(target: .loadCart, completion: { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let response):
                self.cartOrders.removeAll()
                self.cartOrders.append(contentsOf: response.items)
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }

}
