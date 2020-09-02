//
//  CheckoutModel.swift
//  Pharmacy
//
//  Created by CGI-Kite on 31.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit
import EventsTree

protocol CheckoutInput {
    func loadOrder()
}

final class CheckoutModel: EventNode {
    
    unowned var output: CheckoutOutput!
    
    func loadCustomer() {
        if let customer = UserSession.shared.getUser() {
            output.setupCustomer(name: customer.name, phone: customer.phone, email: customer.email ?? "")
        }
    }
    
}

extension CheckoutModel: CheckoutInput {
    
    func loadOrder() {
        loadCustomer()
    }
}
