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
    var releaseForm: String
    let manufacturerName: String
    let manufacturerCountryCode: String
    var minPrice: Decimal?
    var maxPrice: Decimal?
    var liked: Bool
    var pictureUrls: [String]
    
    enum Keys: String, CodingKey {
        case globalProductId
        case rusName
        case releaseForm
        case pictures
        case url
        case manufacturerData
        case localName
        case iso3CountryCode
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
        
        var picturesUnkeyedContainer = try? container.nestedUnkeyedContainer(forKey: .pictures)
        let urlContainer = try? picturesUnkeyedContainer?.nestedContainer(keyedBy: Keys.self)
        pictureUrls = []
        if let pictureUrl = try? urlContainer?.decode(String.self, forKey: .url) {
            pictureUrls = [pictureUrl]
        }
        
        let manufactureContainer = try container.nestedContainer(keyedBy: Keys.self, forKey: .manufacturerData)
        manufacturerName = try manufactureContainer.decode(String.self, forKey: .localName)
        manufacturerCountryCode = try manufactureContainer.decode(String.self, forKey: .iso3CountryCode)
        
        let priceContainer = try? container.nestedContainer(keyedBy: Keys.self, forKey: .pharmacyProductsAggregationData)
        minPrice = try? priceContainer?.decode(Decimal.self, forKey: .minPrice)
        maxPrice = try? priceContainer?.decode(Decimal.self, forKey: .maxPrice)
        liked = (try? container.decode(Bool.self, forKey: .liked)) ?? false
    }
    
    // TODO: - Remove after adding requests
    
    init(title: String, price: String, imageURL: URL?) {
        id = -1
        name = title
        releaseForm = ""
        pictureUrls = []
        manufacturerName = ""
        manufacturerCountryCode = ""
        minPrice = 100
        maxPrice = 200
        liked = false
    }
    
    init(title: String, minPrice: Double, maxPrice: Double, imageURL: String?, releaseForm: String, liked: Bool, productId: Int) {
        id = productId
        name = title
        self.releaseForm = releaseForm
        pictureUrls = [imageURL ?? ""]
        manufacturerName = ""
        manufacturerCountryCode = ""
        self.minPrice = Decimal.init(minPrice)
        self.maxPrice = Decimal.init(maxPrice)
        self.liked = liked
    }
    
    var title: String {
        return name.htmlToString
    }
    var releaseFormFormatted: String {
        releaseForm.htmlToString
    }
    var isAvaliable: Bool {
        minPrice != nil
    }
    
    var price: String {
        return  minPrice?.moneyString(with: currency) ?? "--"
    }
    var imageURL: URL? {
        guard let url = URL(string: pictureUrls[0]) else {
            return nil
        }
        return url
    }
    var currency = "₸"
}
