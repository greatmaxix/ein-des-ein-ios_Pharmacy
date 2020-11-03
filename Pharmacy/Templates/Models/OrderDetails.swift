//
//  OrderDetails.swift
//  Pharmacy
//
//  Created by Mikhail Timoscenko on 02.11.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation

struct OrderDetailsResponse: Codable {

    var item: OrderDetails

    enum Keys: String, CodingKey {
        case item
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)

        item = try container.decode(OrderDetails.self, forKey: .item)
    }
}

struct DetailedOrderContact: Codable {

    var name: String?
    var phone: String?
    var email: String?

    enum Keys: String, CodingKey {
        case name
        case phone
        case email
    }

}

struct OrderDetailsDelivery: Codable {
    var comment: String?
    var street: String?
    var house: String?
    var apartment: String?
    var type: String?

    enum Keys: String, CodingKey {
        case comment
        case address
        case type
        case apartment
        case house
        case street
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)

        comment = try? container.decode(String.self, forKey: .comment)
        type = try? container.decode(String.self, forKey: .type)

        let addressContainer = try? container.nestedContainer(keyedBy: Keys.self, forKey: .address)

        street = try? addressContainer?.decode(String.self, forKey: .street)
        house = try? addressContainer?.decode(String.self, forKey: .house)
        apartment = try? addressContainer?.decode(String.self, forKey: .apartment)
    }
}

struct OrderDetails: Codable {

    var orderId: Int?
    var contactInfo: DetailedOrderContact?
    var status: String?
    var deliveryInfo: OrderDetailsDelivery?
    var paymentType: String?
    var pharmacy: PharmacyOrder?
    var products: [CartMedicine]?
    var deliverPrice: Decimal?
    var totalCost: Decimal?

    enum Keys: String, CodingKey {
        case products = "pharmacyProductOrderDataList"
        case orderId
        case status
        case contactInfo
        case deliveryInfo
        case paymentType
        case pharmacy
        case deliverPrice
        case totalCost = "pharmacyProductsTotalPrice"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)

        orderId = try? container.decode(Int.self, forKey: .orderId)
        contactInfo = try? container.decode(DetailedOrderContact.self, forKey: .contactInfo)
        products = try? container.decode([CartMedicine].self, forKey: .products)
        deliveryInfo = try? container.decode(OrderDetailsDelivery.self, forKey: .deliveryInfo)
        paymentType = try? container.decode(String.self, forKey: .paymentType)
        status = try? container.decode(String.self, forKey: .status)
        pharmacy = try? container.decode(PharmacyOrder.self, forKey: .pharmacy)
        deliverPrice = try? container.decode(Decimal.self, forKey: .deliverPrice)
        totalCost = try? container.decode(Decimal.self, forKey: .totalCost)
    }
}
