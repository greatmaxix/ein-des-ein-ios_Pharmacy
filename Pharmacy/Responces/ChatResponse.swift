//
//  ChatResponse.swift
//  Pharmacy
//
//  Created by Egor Bozko on 04.11.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import UIKit

struct ChatListResponse: Codable, Equatable {
    var items: [Chat]
}

struct CreateMessageResponse: Codable, Equatable {
    let item: ChatMessage
}

struct MessageListResponse: Codable, Equatable {
    let items: [ChatMessage]
}

// From Mercury

struct ChatMessagesResponse: Codable, Equatable {
    struct BodyResponse: Codable, Equatable {
        var item: ChatMessage
    }
    var type: String
    var body: BodyResponse
    
    enum Keys: CodingKey {
        case type, body, data
    }
    
    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: Keys.self)
        self.type = try c.decode(String.self, forKey: .type)
        if c.contains(.body) {
            body = try c.decode(BodyResponse.self, forKey: .body)
        } else {
            body = try c.decode(BodyResponse.self, forKey: .data)
        }
        
    }
}
