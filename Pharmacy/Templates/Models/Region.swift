//
//  Region.swift
//  Pharmacy
//
//  Created by CGI-Kite on 07.09.2020.
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

final class Region: Decodable {
    
    let regionId: Int
    let name: String
    let subRegions: [Region]?
    let level: Int

    enum Keys: String, CodingKey {
        case id
        case name
        case lvl
        case children
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        regionId = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        subRegions = try? container.decode([Region].self, forKey: .children)
        level = try container.decode(Int.self, forKey: .lvl)
    }
}
