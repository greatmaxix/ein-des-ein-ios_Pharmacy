//
//  Chat.swift
//  Pharmacy
//
//  Created by Egor Bozko on 05.11.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation

struct Chat: Codable, Equatable {
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
    var lastMessage: LastMessage
}

struct ChatUser: Codable, Equatable {
    var id: Int
    var name: String
    var uuid: String
    var avatar: [String]?
    var type: String
}

struct LastMessage: Codable, Equatable {
    var id: Int
    var chatId: Int
    var chatNumber: Int
    var createdAt: String
    var ownerType: String
    var ownerUuid: String
}

struct ChatMessage: Codable, Equatable {
    var text: String
    var id: Int
    var chatId: Int
    var chatNumber: Int
    var createdAt: String
    var ownerType: String
    var ownerUuid: String
}
