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
    case uploadImage(UIImage)
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
        case .uploadImage: return "customer/image"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .messageList, .chatList, .chatDetails, .lastOpened:
            return .get
        case .createMessage, .create, .uploadImage:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .chatDetails, .messageList, .lastOpened, .chatList:
            return .requestPlain
        case .create(let type):
            return .requestParameters(parameters: ["type": type.rawValue], encoding: JSONEncoding.default)
        case .createMessage(_, let message):
            return .requestParameters(parameters: ["text": message], encoding: JSONEncoding.default)
        case .uploadImage(let image):
            let data = image.jpegData(compressionQuality: 1.0) ?? Data()
            let formData: [Moya.MultipartFormData] = [Moya.MultipartFormData(provider: .data(data), name: "user_image", fileName: "image.jpeg", mimeType: "image/jpeg")]
            return .uploadMultipart(formData)
        }
    }
}
