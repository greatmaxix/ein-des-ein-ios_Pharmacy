//
//  ProductModel.swift
//  Pharmacy
//
//  Created by Egor Bozko on 16.11.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation

struct ChatProduct: Decodable, Equatable {
    let id: Int
    let name: String
    let releaseForm: String
    let pictures: [URL]
    let priceRange: PriceRange
    var liked: Bool
    
    var title: String {
        return name.htmlToString
    }
    var releaseFormFormatted: String {
        releaseForm.htmlToString
    }
    
    var asMedicine: Medicine {
        return Medicine(title: name, minPrice: priceRange.minPrice, maxPrice: priceRange.maxPrice, imageURL: pictures.first?.absoluteString, releaseForm: releaseForm, liked: liked, productId: id)
    }
    
    static func == (lhs: ChatProduct, rhs: ChatProduct) -> Bool {
        return lhs.id == rhs.id
    }
    
    enum Key: CodingKey {
        case globalProductId
        case rusName
        case releaseForm
        case pictures
        case pharmacyProductsAggregationData
        case liked
    }
    
    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: Key.self)
        id = try c.decode(Int.self, forKey: .globalProductId)
        name = try c.decode(String.self, forKey: .rusName)
        releaseForm = try c.decode(String.self, forKey: .releaseForm)
        pictures = try c.decode([URL].self, forKey: .pictures)
        priceRange = try c.decode(PriceRange.self, forKey: .pharmacyProductsAggregationData)
        liked = try c.decode(Bool.self, forKey: .liked)
    }
    
    init(liked: Bool) {
        id = 791
        name = "Лазолван"
        releaseForm = "Таблетки 50мг"
        pictures = []
        priceRange = PriceRange(min: 120.45, max: 150.34)
        self.liked = liked
    }
    
    mutating func updateLike(value: Bool) {
        self.liked = value
    }
}
