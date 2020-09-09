//
//  Medicine.swift
//  Pharmacy
//
//  Created by Anton Bal’ on 12.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation

struct Medicine: Codable {
    let id: Int
    let name: String
    let releaseForm: String
    let manufacturerName: String
    let manufacturerCountryCode: String
    let minPrice: Double
    let maxPrice: Double
    let liked: Bool
    let pictureUrls: [String]?
    
    enum Keys: String, CodingKey {
        case globalProductId
        case rusName
        case releaseForm
        case pictures
        case url
        case manufacturerData
        case localName
        case iso3CountryCountryCode
        case pharmacyProductsAggregationData
        case minPrice
        case maxPrice
        case liked
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        id = try container.decode(Int.self, forKey: .globalProductId)
        name = try container.decode(String.self, forKey: .rusName)
        releaseForm = try container.decode(String.self, forKey: .releaseForm)
        
        let picturesContainer = try container.nestedContainer(keyedBy: Keys.self, forKey: .pictures)
        pictureUrls = try? picturesContainer.decode([String].self, forKey: .url)
        
        let manufactureContainer = try container.nestedContainer(keyedBy: Keys.self, forKey: .manufacturerData)
        manufacturerName = try container.decode(String.self, forKey: .localName)
        manufacturerCountryCode = try container.decode(String.self, forKey: .iso3CountryCountryCode)
        
        let priceContainer = try container.nestedContainer(keyedBy: Keys.self, forKey: .pharmacyProductsAggregationData)
        minPrice = try container.decode(Double.self, forKey: .minPrice)
        maxPrice = try container.decode(Double.self, forKey: .maxPrice)
        liked = try container.decode(Bool.self, forKey: .liked)
    }
    
    // TODO: - Remove after adding requests
    
    init(tittle: String, price: String, imageURL: URL?) {
        id = -1
        name = tittle
        releaseForm = ""
        pictureUrls = []
        manufacturerName = ""
        manufacturerCountryCode = ""
        minPrice = 100
        maxPrice = 200
        liked = false
    }
    
    var tittle: String {
        return name
    }
    var price: String {
        return "\(minPrice)"
    }
    var imageURL: URL? {
        return nil
    }
    var currency = "₽"
}
