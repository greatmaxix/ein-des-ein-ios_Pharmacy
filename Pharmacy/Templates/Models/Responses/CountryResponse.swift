//
//  CountryResponse.swift
//  Pharmacy
//
//  Created by Sergey berdnik on 29.10.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation

struct CountryResponse: Decodable {
    
    enum Keys: String, CodingKey {
        case items
    }
    
    let country: [Country]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        country = try container.decode([Country].self, forKey: .items)
    }
}
