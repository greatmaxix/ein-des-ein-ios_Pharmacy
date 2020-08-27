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
    
}

protocol BasketModelOutput: class {}

final class BasketModel: Model {
    
    weak var output: BasketModelOutput!
    
}

// MARK: - BasketViewControllerOutput

extension BasketModel: BasketViewControllerOutput {
    
}
