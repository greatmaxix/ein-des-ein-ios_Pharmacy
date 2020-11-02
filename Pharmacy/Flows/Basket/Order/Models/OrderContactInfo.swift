//
//  OrderContactInfo.swift
//  Pharmacy
//
//  Created by Mikhail Timoscenko on 01.11.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation

class OrderContactInfo: NSObject {

    var name: String
    var phone: String
    var email: String?

    init(name: String, phone: String, email: String?) {
        self.name = name
        self.phone = phone
        self.email = email

        super.init()
    }

}
