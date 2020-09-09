//
//  RegionResponse.swift
//  Pharmacy
//
//  Created by CGI-Kite on 09.09.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation

struct RegionResponse: Decodable {
    
    enum Keys: String, CodingKey {
        case items
    }
    
    let regions: [Region]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        regions = try container.decode([Region].self, forKey: .items)
    }
}
