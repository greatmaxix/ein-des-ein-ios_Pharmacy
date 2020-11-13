//
//  Sender.swift
//  Pharmacy
//
//  Created by Egor Bozko on 03.11.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import MessageKit

struct ChatSender: SenderType, Equatable {
    var senderId: String
    var displayName: String
    
    static func guest() -> ChatSender {
        return ChatSender(senderId: "-2", displayName: "Гость")
    }
    
    static func currentUser() -> ChatSender {
        switch UserSession.shared.authorizationStatus {
        case .authorized: return ChatSender(senderId: "\(UserSession.shared.userUUID ?? "")", displayName: "customer")
        case .notAuthorized: return guest()
        }
    }
}
