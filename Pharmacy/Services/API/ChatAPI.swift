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
    case upload(data: Data, mime: String, name: String)
    case sendImage(chatId: Int, uuid: String)
    case createProductMessage(chatId: Int, productId: Int)
    case closeChat(id: Int)
    case continueChat(id: Int)
    case evaluating(chatId: Int, evaluating: ChatEvaluation)
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
        case .upload: return "customer/image"
        case .sendImage(let chatId, let uuid): return "chat/chat/\(chatId)/application/\(uuid)"
        case .createProductMessage(let chatId, let productId): return "chat/chat/\(chatId)/global-product/\(productId)"
        case .closeChat(let id): return "customer/chat/\(id)/close"
        case .continueChat(let id): return "customer/chat/\(id)/continue"
        case .evaluating(let chatId, _): return "customer/chat/\(chatId)/evaluate"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .messageList, .chatList, .chatDetails, .lastOpened:
            return .get
        case .createMessage, .create, .upload, .sendImage, .createProductMessage:
            return .post
        case .closeChat, .continueChat, .evaluating:
            return .patch
        }
    }
    
    var task: Task {
        switch self {
        case .chatDetails, .messageList, .lastOpened, .chatList, .sendImage, .createProductMessage, .closeChat, .continueChat:
            return .requestPlain
        case .create(let type):
            return .requestParameters(parameters: ["type": type.rawValue], encoding: JSONEncoding.default)
        case .createMessage(_, let message):
            return .requestParameters(parameters: ["text": message], encoding: JSONEncoding.default)
        case .upload(let data, let mime, let name):
            let formData = [Moya.MultipartFormData(provider: .data(data), name: "file", fileName: name, mimeType: mime)]
            return .uploadMultipart(formData)
        case .evaluating(_, let evaluating):
            return .requestParameters(parameters: evaluating.asDictionary, encoding: JSONEncoding.default)
        }
    }
}
