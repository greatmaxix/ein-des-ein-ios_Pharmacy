//
//  CartResponse.swift
//  Pharmacy
//
//  Created by Mikhail Timoscenko on 28.10.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation

struct CartResponse: Codable {

    var items: [PharmCartOrder]

    enum Keys: String, CodingKey {
        case items
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)

        items = try container.decode([PharmCartOrder].self, forKey: .items)
    }

}

struct PharmCartOrder: Codable {

    var products: [CartMedicine]
    var id: Int
    var name: String
    var location: String?
    var imageURL: URL?
    var deliveryCost: Decimal = 150

    enum Keys: String, CodingKey {
        case products = "pharmacyProducts"
        case id
        case name
        case location
        case address
        case logo
        case url
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)

        products = try container.decode([CartMedicine].self, forKey: .products)
        id = try container.decode(Int.self, forKey: .id)

        name = try container.decode(String.self, forKey: .name)

        let addressConatiner = try? container.nestedContainer(keyedBy: Keys.self, forKey: .location)
        location = try? addressConatiner?.decode(String.self, forKey: .address)

        let nestedContainer = try container.nestedContainer(keyedBy: Keys.self, forKey: .logo)
        if let stringURL: String = try? nestedContainer.decode(String.self, forKey: .url) {
            imageURL = URL(string: stringURL)
        }
    }

    var totalCost: Decimal {
        var cost: Decimal = 0
        for product in products {
            cost += (product.price ?? 0) * Decimal(product.productCount)
        }

        return cost
    }

    var totalCostWithDelivery: Decimal {
        return totalCost + deliveryCost
    }

    var totalProducts: Int {
        products.reduce(0) { (result, product) -> Int in
            result + product.productCount
        }
    }
}

struct CartMedicine: Codable {

    var pharmacyProductId: Int
    var name: String
    var releaseForm: String
    var price: Decimal?
    var productCount: Int
    var pictureUrls: [String]
    var liked: Bool
    var manufacturerName: String?

    enum Keys: String, CodingKey {
        case rusName
        case products
        case pharmacyProductId
        case releaseForm
        case price
        case productCount
        case pictures
        case liked
        case url
        case localName
        case manufacturerData
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)

        pharmacyProductId = try container.decode(Int.self, forKey: .pharmacyProductId)
        name = try container.decode(String.self, forKey: .rusName)
        releaseForm = try container.decode(String.self, forKey: .releaseForm)

        var picturesUnkeyedContainer = try? container.nestedUnkeyedContainer(forKey: .pictures)
        let urlContainer = try? picturesUnkeyedContainer?.nestedContainer(keyedBy: Keys.self)
        pictureUrls = []
        if let pictureUrl = try? urlContainer?.decode(String.self, forKey: .url) {
            pictureUrls = [pictureUrl]
        }

        let manufactureContainer = try container.nestedContainer(keyedBy: Keys.self, forKey: .manufacturerData)
        manufacturerName = try manufactureContainer.decode(String.self, forKey: .localName)

        liked = (try? container.decode(Bool.self, forKey: .liked)) ?? false
        productCount = try container.decode(Int.self, forKey: .productCount)
        price = try container.decode(Decimal.self, forKey: .price)
    }

}
