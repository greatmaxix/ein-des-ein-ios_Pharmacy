//
//  ChatResponse.swift
//  Pharmacy
//
//  Created by Egor Bozko on 04.11.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import UIKit
import Moya

struct ChatListResponse: Decodable, Equatable {
    var items: [Chat]
}

struct ChatResponse: Decodable, Equatable {
    var item: Chat
}

struct CreateMessageResponse: Decodable, Equatable {
    let item: ChatMessage
}

struct MessageListResponse: Decodable, Equatable {
    let items: [ChatMessage]
}

struct UploadedImage: Decodable, Equatable {
    let uuid: String
    let url: String
}

struct CreateProductMessageResponse: Decodable, Equatable {
    let item: Product
}

typealias UploadImageResult = Result<CustomerImageUploadResponse, MoyaError>

struct CustomerImageUploadResponse: Decodable, Equatable {
    let item: UploadedImage
}

// From Mercury

enum ChatMessageType: String, Decodable {
    case message, application, changeStatus = "change_status", globalProduct = "global_product"
}

struct ChatMessagesResponse: Decodable, Equatable {
    
    struct ResponseBody: Decodable, Equatable {
        var item: ChatMessage
    }
    
    struct ChatResponseBody: Decodable, Equatable {
        var item: ChatResponse
    }
    
    var type: ChatMessageType
    var body: ResponseBody?
    var chatBody: ChatResponseBody?
    
    enum Keys: CodingKey {
        case type, body
    }
    
    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: Keys.self)
        type = try c.decode(ChatMessageType.self, forKey: .type)
        if type == .changeStatus {
            chatBody = try c.decode(ChatResponseBody.self, forKey: .body)
        } else {
            body = try c.decode(ResponseBody.self, forKey: .body)
        }
    }
}
