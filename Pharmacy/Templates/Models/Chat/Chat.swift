//
//  Chat.swift
//  Pharmacy
//
//  Created by Egor Bozko on 05.11.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation

struct Chat: Decodable, Equatable {
    var id: Int
    var createdAt: String
    var customer: ChatUser
    var user: ChatUser
    var status: ChatService.ChatStatus
    var mark: String?
    var type: String
    var isAutomaticClosed: Bool
    var closedAt: String?
    var topicName: String
    var lastMessage: ChatMessage
}

struct ChatUser: Decodable, Equatable {
    var id: Int
    var name: String
    var uuid: String
    var avatar: [String]?
    var type: String
}

struct LastMessage: Decodable, Equatable {
    var id: Int
    var chatId: Int
    var chatNumber: Int
    var createdAt: String
    var ownerType: String
    var ownerUuid: String
}

struct ChatMessage: Decodable, Equatable {
    
    var id: Int
    var chatId: Int
    var chatNumber: Int
    var createdAt: String
    var ownerType: String
    var ownerUuid: String
    
    var text: String?
    var product: ChatProduct?
    var file: FileAttachment?
    var recipe: ChatRecipe?
    
    var type = ChatMessageType.message
    
    var asMessage: Message {
        let sender = ChatSender(senderId: ownerUuid, displayName: ownerType)
        switch type {
        case .message: return Message(text ?? "", sender: sender, messageId: "\(id)", date: createdAt.date() ?? Date())
        case .globalProduct: return Message(.product(product!), sender: sender, messageId: "\(id)", date: createdAt.date() ?? Date())
        case .application: return Message(.application(file!), sender: sender, messageId: "\(id)", date: createdAt.date() ?? Date())
        case .changeStatus: return Message(.chatClosing, sender: sender, messageId: "\(id)", date: createdAt.date() ?? Date())
        case .recipe: return Message(.recipe(recipe!), sender: sender, messageId: "\(id)", date: createdAt.date() ?? Date())
        }
    }
    
    var isSenderCurrentUser: Bool {
        return ownerUuid == UserSession.shared.userUUID
    }
    
    enum Key: CodingKey {
        case id, chatId, chatNumber, createdAt, ownerType, ownerUuid, text, globalProductCard, file, recipeImage
    }
    
    public static func == (lhs: ChatMessage, rhs: ChatMessage) -> Bool {
        return lhs.id == rhs.id
    }
    
    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: Key.self)
        id = try c.decode(Int.self, forKey: .id)
        chatId = try c.decode(Int.self, forKey: .chatId)
        chatNumber = try c.decode(Int.self, forKey: .chatNumber)
        createdAt = try c.decode(String.self, forKey: .createdAt)
        ownerType = try c.decode(String.self, forKey: .ownerType)
        ownerUuid = try c.decode(String.self, forKey: .ownerUuid)
        
        if c.contains(.text) {
            text = try c.decode(String.self, forKey: .text)
        } else if c.contains(.globalProductCard) {
            product = try c.decode(ChatProduct.self, forKey: .globalProductCard)
            type = .globalProduct
        } else if c.contains(.file) {
            file = try c.decode(FileAttachment.self, forKey: .file)
            type = .application
        } else if c.contains(.recipeImage) {
            recipe = try c.decode(ChatRecipe.self, forKey: .recipeImage)
            type = .recipe
        }
    }
}
