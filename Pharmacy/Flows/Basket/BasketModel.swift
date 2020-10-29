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
    var numberOfSections: Int { get }

    func numberOfRows(in section: Int) -> Int
    func section(at index: Int) -> PharmCartOrder
    func medecine(at indexPath: IndexPath) -> CartMedicine
    func load()
    func sectionClosureChanged(at index: Int)
}

protocol BasketModelOutput: class {
    func cartDidLoad()
    func reloadSection(at index: Int)
}

final class BasketModel: Model {
    
    weak var output: BasketModelOutput!

    private var loader = DataManager<ProductCartAPI, CartResponse>()
    private var cartOrders: [PharmCartOrder] = [] {
        didSet {
            sectionClosureStates = Array(repeating: false, count: cartOrders.count)
        }
    }
    private var sectionClosureStates: [Bool] = []
}

// MARK: - BasketViewControllerOutput

extension BasketModel: BasketViewControllerOutput {

    func section(at index: Int) -> PharmCartOrder {
        return cartOrders[index]
    }

    var numberOfSections: Int {
        return cartOrders.count
    }

    func numberOfRows(in section: Int) -> Int {
        if sectionClosureStates[section] == false {
            return 0
        }

        return cartOrders[section].products.count
    }

    func medecine(at indexPath: IndexPath) -> CartMedicine {
        return cartOrders[indexPath.section].products[indexPath.row]
    }

    func sectionClosureChanged(at index: Int) {
        sectionClosureStates[index] = !sectionClosureStates[index]
        output.reloadSection(at: index)
    }

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
            
            self.output.cartDidLoad()
        })
    }

}
