//
//  Sender.swift
//  Pharmacy
//
//  Created by Egor Bozko on 03.11.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import MessageKit

struct ChatSender: SenderType {
    var senderId: String
    var displayName: String
    
    static func guest() -> ChatSender {
        return ChatSender(senderId: "-2", displayName: "Гость")
    }
    
    static func currentUser() -> ChatSender {
        switch UserSession.shared.authorizationStatus {
        case .authorized(let id): return ChatSender(senderId: "\(id)", displayName: UserSession.shared.user?.name ?? "")
        case .notAuthorized: return guest()
        }
    }
}
