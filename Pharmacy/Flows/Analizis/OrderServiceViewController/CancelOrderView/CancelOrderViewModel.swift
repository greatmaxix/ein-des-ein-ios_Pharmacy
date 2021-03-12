//
//  CancelOrderViewModel.swift
//  Pharmacy
//
//  Created by Anna Yatsun on 09.03.2021.
//  Copyright © 2021 pharmacy. All rights reserved.
//

import Foundation

import Foundation
import EventsTree


protocol CancelOrderViewModelInput: class {
    func close()
    
}

protocol CancelOrderViewModelOutput: class {

}


final class CancelOrderViewModel: Model {
    
    weak var output: CancelOrderViewModelOutput!
  
}

extension CancelOrderViewModel: CancelOrderViewOutput {
    
    func close() {
        raise(event: ProfileEvent.close)
    }
}
