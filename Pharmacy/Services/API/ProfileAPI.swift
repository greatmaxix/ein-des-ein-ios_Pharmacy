//
//  ProfileAPI.swift
//  Pharmacy
//
//  Created by CGI-Kite on 17.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import Moya

enum ProfileAPI {
    
    case getCustomer
    case updateCustomer(name: String, email: String, avatarUuid: String)
    case sendImage(imageData: Data, mime: String, fileName: String)
    case updateRegion(regionId: Int)
}

extension ProfileAPI: RequestConvertible {
    
    var path: String {
        switch self {
        case .getCustomer:
            return "customer/customer"
        case .updateCustomer:
            return "customer/customer"
        case .sendImage:
            return "customer/image"
        case .updateRegion:
            return "customer/customer/region"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getCustomer:
            return .get
        case .updateCustomer:
            return .put
        case .sendImage:
            return .post
        case .updateRegion:
            return .patch
        }
    }
    
    var task: Task {
        switch self {
        case .getCustomer:
            return .requestPlain
        case .updateCustomer(name: let name, email: let email, avatarUuid: let avatarUuid):
            print("zxcv \(self.baseURL.absoluteString)\(self.path)")
            return .requestParameters(parameters: ["name": name, "email": email, "avatarUuid": avatarUuid], encoding: JSONEncoding.default)
        case .sendImage(imageData: let imageData, mime: let mime, fileName: let fileName):
            let multipart = MultipartFormData(provider: .data(imageData), name: "file", fileName: fileName, mimeType: mime)
            return .uploadMultipart([multipart])
        case .updateRegion(let regionId):
            return .requestParameters(parameters: ["regionId": regionId],
                                      encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .sendImage:
            return ["Content-type": "multipart/form-data"]
        default:
            return ["Content-type": "application/json"]
        }
    }
}
