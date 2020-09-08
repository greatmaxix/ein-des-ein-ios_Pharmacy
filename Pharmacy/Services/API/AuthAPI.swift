//
//  APIAuthLayer.swift
//  Pharmacy
//
//  Created by Mikhail Timoscenko on 16.06.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import Moya

enum AuthAPI {
    // swiftlint:disable all

    case register(name: String, phone: String, email: String?)
    case requestCodeFor(phone: String)
    case login(phone: String, code: String)
    case logout(refreshToken: String)
}

extension AuthAPI: RequestConvertible {

    var path: String {
        switch self {
        case .register:
            return "customer/registration"
        case .requestCodeFor:
            return "customer/auth"
        case .login:
            return "customer/login"
        case .logout:
            return "customer/logout"
        }
    }

    var method: Moya.Method {
        switch self {
        case .register:
            return .post
        case .login:
            return .post
        case .requestCodeFor:
            return .post
        case .logout:
            return .post
        }
    }

    var task: Task {
        switch self {
        case .requestCodeFor(let phone):
            return .requestParameters(parameters: [
                "phone" : phone], encoding: JSONEncoding.default)
        case .register(name: let name, phone: let phone, let email):
            var params = ["name" : name, "phone" : phone]
            if let email = email {
                params["email"] = email
            }
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .login(phone: let phone, code: let code):
            return .requestParameters(parameters: ["phone": phone, "code": code], encoding: JSONEncoding.default)
        case .logout(refreshToken: let refreshToken):
            return .requestParameters(parameters: ["refreshToken": refreshToken], encoding: JSONEncoding.default)
        }
    }
}

