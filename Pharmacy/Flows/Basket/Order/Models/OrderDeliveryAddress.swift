//
//  OrderDeliveryAddress.swift
//  Pharmacy
//
//  Created by Mikhail Timoscenko on 01.11.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation

class OrderDeliveryAddress: NSObject {

    var city: String?
    var street: String?
    var house: String?
    var appartment: String?

    init(city: String?, street: String?, house: String?, appartment: String?) {
        self.city = city
        self.street = street
        self.house = house
        self.appartment = appartment

        super.init()
    }

}
