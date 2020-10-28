//
//  PriceRange.swift
//  Pharmacy
//
//  Created by Sapa Denys on 01.10.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation

struct PriceRange: Decodable {
    
    // MARK: - Properties
    let minPrice: Decimal
    let maxPrice: Decimal
    
    // MARK: - Init / Deinit methods
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        minPrice = try container.decode(Decimal.self, forKey: .minPrice)
        maxPrice = try container.decode(Decimal.self, forKey: .maxPrice)
    }
}

// MARK: - External declaration
extension PriceRange {
    
    private enum CodingKeys: String, CodingKey {
        case minPrice
        case maxPrice
    }
}
