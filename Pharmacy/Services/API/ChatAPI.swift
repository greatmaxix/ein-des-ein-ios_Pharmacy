//
//  ChatAPI.swift
//  Pharmacy
//
//  Created by Egor Bozko on 04.11.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import Moya

enum ChatAPI {
    enum ChatRoute: String {
        case doctor, pharmacist
    }

    case chatList
    case chatDetails(String)
    case messageList(Int)
    case createMessage(Int, String)
    case create(ChatRoute)
    case lastOpened
}

extension ChatAPI: RequestConvertible {
    var path: String {
        switch self {
        case .chatList: return "chat/chats"
        case .chatDetails(let id): return "customer/chat/\(id)"
        case .messageList(let id): return "chat/chat/\(id)/messages"
        case .createMessage(let id, _): return "chat/chat/\(id)/message"
        case .create: return "customer/chat"
        case .lastOpened: return "user/chat/last-opened-chats"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .chatList:
            return .get
        case .chatDetails:
            return .get
        case .messageList:
            return .get
        case .createMessage:
            return .post
        case .lastOpened:
            return .get
        case .create:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .create(let type): return .requestParameters(parameters: ["type": type.rawValue], encoding: JSONEncoding.default)
        case .chatList: return .requestPlain
        case .lastOpened: return .requestPlain
        case .chatDetails: return .requestPlain
        case .messageList: return .requestPlain
        case .createMessage(_, let message): return .requestParameters(parameters: ["text": message], encoding: JSONEncoding.default)
        }
    }
}
