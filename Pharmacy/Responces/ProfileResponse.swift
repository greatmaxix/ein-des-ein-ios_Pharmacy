//
//  ProfileResponse.swift
//  Pharmacy
//
//  Created by CGI-Kite on 18.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation

struct ProfileResponse: Codable, Equatable {
    enum Keys: String, CodingKey {
        case item
    }
    let user: User
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        user = try container.decode(User.self, forKey: .item)
    }
}
