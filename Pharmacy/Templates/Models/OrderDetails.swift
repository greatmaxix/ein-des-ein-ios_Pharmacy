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

struct OrderDetails: Codable {

    var orderId: Int?
    var contactInfo: DetailedOrderContact?
    var status: String?
    var deliveryInfo: DeliveryInfo?
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
        deliveryInfo = try? container.decode(DeliveryInfo.self, forKey: .deliveryInfo)
        paymentType = try? container.decode(String.self, forKey: .paymentType)
        status = try? container.decode(String.self, forKey: .status)
        pharmacy = try? container.decode(PharmacyOrder.self, forKey: .pharmacy)
        deliverPrice = try? container.decode(Decimal.self, forKey: .deliverPrice)
        totalCost = try? container.decode(Decimal.self, forKey: .totalCost)
    }
}
