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
    case sendImage(image: UIImage)
}

extension ProfileAPI: TargetType, AccessTokenAuthorizable {
    
    var sampleData: Data {
        return Data()
    }
    
    var authorizationType: AuthorizationType? {
        return .bearer
    }
    
    var baseURL: URL {
        return URL(string: "https://api.pharmacies.release.fmc-dev.com/api/v1")!
    }
    
    var path: String {
        switch self {
        case .getCustomer:
            return "customer/customer"
        case .updateCustomer:
            return "customer/customer"
        case .sendImage:
            return "customer/image"
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
        }
    }
    
    var task: Task {
        switch self {
        case .getCustomer:
            return .requestPlain
        case .updateCustomer(name: let name, email: let email, avatarUuid: let avatarUuid):
            return .requestParameters(parameters: ["name": name, "email": email, "avatarUuid": avatarUuid], encoding: JSONEncoding.default)
        case .sendImage(image: let image):
            let data = image.pngData()
            return .requestParameters(parameters: ["file": data], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
}
