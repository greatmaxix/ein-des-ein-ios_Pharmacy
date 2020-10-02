//
//  Product.swift
//  Pharmacy
//
//  Created by Anton Bal’ on 13.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import Moya

struct Product: Decodable {
    let identifier: Int
    let name: String
    let releaseForm: String
    let description: String
    let category: String
    
    var imageURLs: [URL]
    
    let activeSubstances: [String]
    
    let manufacturer: Manufacturer
    
    let priceRange: PriceRange
    let isLiked: Bool

//    let title: String
//    let subtitle: String
//
//    let fromPrice: String
//    let toPrice: String
//    let currency: String
//    let analog: String
//    let tags: [String]
//    let company: String
    
    enum Keys: String, CodingKey {
        case globalProductId
        case rusName
        case releaseForm
        case description
        case category
        case pictures
        case activeSubstances
        
        case manufacturerData
//        case localName
//        case iso3CountryCode
        
        case pharmacyProductsAggregationData
//        case minPrice
//        case maxPrice
        
        
        
        case liked
        
        case url
//        case manufacturerData
//        case localName
//        case iso3CountryCode
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        identifier = try container.decode(Int.self, forKey: .globalProductId)
        
        name = try container.decode(String.self, forKey: .rusName)
        releaseForm = try container.decode(String.self, forKey: .releaseForm)
        description = try container.decode(String.self, forKey: .description)
        category = try container.decode(String.self, forKey: .category)

        var picturesUnkeyedContainer = try? container.nestedUnkeyedContainer(forKey: .pictures)
        let urlContainer = try? picturesUnkeyedContainer?.nestedContainer(keyedBy: Keys.self)
        imageURLs = []
        if let pictureUrl = try? urlContainer?.decode(URL.self, forKey: .url) {
            imageURLs = [pictureUrl]
        }
        
        activeSubstances = try container.decode([String].self, forKey: .activeSubstances)
        
        manufacturer = try container.decode(Manufacturer.self, forKey: .manufacturerData)
        
        priceRange = try container.decode(PriceRange.self, forKey: .pharmacyProductsAggregationData)
        isLiked = (try? container.decode(Bool.self, forKey: .liked)) ?? false
//
//        let manufactureContainer = try container.nestedContainer(keyedBy: Keys.self, forKey: .manufacturerData)
//        manufacturerName = try manufactureContainer.decode(String.self, forKey: .localName)
//        manufacturerCountryCode = try manufactureContainer.decode(String.self, forKey: .iso3CountryCode)
//
//        let priceContainer = try? container.nestedContainer(keyedBy: Keys.self, forKey: .pharmacyProductsAggregationData)
//        minPrice = try? priceContainer?.decode(Decimal.self, forKey: .minPrice)
//        maxPrice = try? priceContainer?.decode(Decimal.self, forKey: .maxPrice)
        
    }
}

extension Product: ParseKeyPath {
    
    static var parseKeyPathExtension: String {
        "item"
    }
}
