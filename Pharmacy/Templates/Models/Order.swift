//
//  Order.swift
//  Pharmacy
//
//  Created by Mikhail Timoscenko on 02.11.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation

struct OrdersResponse: Codable {

    var items: [Order]

    enum Keys: String, CodingKey {
        case items
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)

        items = try container.decode([Order].self, forKey: .items)
    }
}

struct PharmacyOrder: Codable {

    var id: Int
    var name: String
    var location: String?
    var imageURL: URL?

    enum Keys: String, CodingKey {
        case id
        case name
        case location
        case address
        case logo
        case url
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)

        id = try container.decode(Int.self, forKey: .id)

        name = try container.decode(String.self, forKey: .name)

        var locationContainer = try? container.nestedUnkeyedContainer(forKey: .location)
        let addressConatiner = try? locationContainer?.nestedContainer(keyedBy: Keys.self)
        location = try? addressConatiner?.decode(String.self, forKey: .address)

        let nestedContainer = try container.nestedContainer(keyedBy: Keys.self, forKey: .logo)
        if let stringURL: String = try? nestedContainer.decode(String.self, forKey: .url) {
            imageURL = URL(string: stringURL)
        }
    }
}

struct DeliveryInfo: Codable {

    var type: String?
    var comment: String?
    var city: String?
    var street: String?
    var house: String?
    var apartment: String?

    enum Keys: String, CodingKey {
        case type
        case comment
        case address
        case city
        case street
        case house
        case apartment
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)

        type = try container.decode(String.self, forKey: .type)
        comment = try container.decode(String.self, forKey: .comment)

        var picturesUnkeyedContainer = try? container.nestedUnkeyedContainer(forKey: .address)
        let addressContainer = try? picturesUnkeyedContainer?.nestedContainer(keyedBy: Keys.self)

        city = try? addressContainer?.decode(String.self, forKey: .city)
        street = try? addressContainer?.decode(String.self, forKey: .street)
        house = try? addressContainer?.decode(String.self, forKey: .house)
        apartment = try? addressContainer?.decode(String.self, forKey: .apartment)
    }
}

struct Order: Codable {

    var orderId: Int?
    var orderCreatedAt: String?
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
        case orderCreatedAt
        case deliveryInfo
        case paymentType
        case pharmacy
        case deliverPrice
        case totalCost = "pharmacyProductsTotalPrice"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)

        orderId = try? container.decode(Int.self, forKey: .orderId)
        orderCreatedAt = try? container.decode(String.self, forKey: .orderCreatedAt)
        products = try? container.decode([CartMedicine].self, forKey: .products)
        deliveryInfo = try? container.decode(DeliveryInfo.self, forKey: .deliveryInfo)
        paymentType = try? container.decode(String.self, forKey: .paymentType)
        status = try? container.decode(String.self, forKey: .status)
        pharmacy = try? container.decode(PharmacyOrder.self, forKey: .pharmacy)
        deliverPrice = try? container.decode(Decimal.self, forKey: .deliverPrice)
        totalCost = try? container.decode(Decimal.self, forKey: .totalCost)
    }
}
