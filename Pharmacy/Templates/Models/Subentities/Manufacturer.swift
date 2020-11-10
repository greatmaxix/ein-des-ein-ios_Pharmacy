//
//  Manufacturer.swift
//  Pharmacy
//
//  Created by Sapa Denys on 01.10.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation

struct Manufacturer: Decodable, Equatable {
    
    // MARK: - Properties
    let name: String
    let countryISOCode: String
    
    // MARK: - Init / Deinit methods
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try container.decode(String.self, forKey: .localName)
        countryISOCode = try container.decode(String.self, forKey: .iso3CountryCode)
    }
}

// MARK: - External declaration
extension Manufacturer {
    
    private enum CodingKeys: String, CodingKey {
        case localName
        case iso3CountryCode
    }
}
