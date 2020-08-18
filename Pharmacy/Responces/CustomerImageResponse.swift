//
//  CustomerImageResponse.swift
//  Pharmacy
//
//  Created by CGI-Kite on 18.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation

struct CustomerImageResponse: Codable, Equatable {
    enum Keys: String, CodingKey {
        case item
    }
    let avatar: Avatar
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        avatar = try container.decode(Avatar.self, forKey: .item)
    }
}
