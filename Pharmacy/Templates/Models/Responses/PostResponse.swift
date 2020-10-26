//
//  PostResponse.swift
//  Pharmacy
//
//  Created by Sergey berdnik on 26.10.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation

struct PostResponse: Codable {
    let message: String?
    let status: String?
    let data: [Int]?
    
    enum Keys: String, CodingKey {
        case message
        case status
        case data
    }
    
    init(from decoder: Decoder) throws {
        let container = try? decoder.container(keyedBy: Keys.self)
        
        message = try container?.decode(String.self, forKey: .message)
        status = try container?.decode(String.self, forKey: .status)
        data = try? container?.decode([Int].self, forKey: .data)
    }
}
