//
//  CancelOrderModel.swift
//  Pharmacy
//
//  Created by Anna Yatsun on 05.03.2021.
//  Copyright © 2021 pharmacy. All rights reserved.
//

import Foundation
import EventsTree


protocol CancelOrderModelInput: class {
    func close()
    
}

protocol CancelOrderModelOutput: class {

}


final class CancelOrderModel: Model {
    
    weak var output: CancelOrderModelOutput!
  
}

extension CancelOrderModel: CancelOrderViewControllerOutput {
    func close() {
        raise(event: ProfileEvent.showCancelView)
    }
}
