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

    case register(name: String, phone: String, email: String)
    case requestCodeFor(phone: String)
    case validate(code: String)

}

extension AuthAPI: TargetType, AccessTokenAuthorizable {

    var authorizationType: AuthorizationType? {
        return .bearer
    }

    // Change this for real one
    var baseURL: URL {
        return URL(string: "https://sample.com")!
    }

    var path: String {
        switch self {
        case .register:
            return ""
        case .requestCodeFor:
            return ""
        case .validate:
            return ""
        }
    }

    var method: Moya.Method {
        switch self {
        case .register:
            return .post
        case .requestCodeFor:
            return .post
        case .validate:
            return .post
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case .validate(let code):
            return .requestParameters(parameters: [
                "code" : code], encoding: JSONEncoding.default)
        case .requestCodeFor(let phone):
            return .requestParameters(parameters: [
                "phone" : phone], encoding: JSONEncoding.default)
        case .register(name: let name, phone: let phone, let email):
            return .requestParameters(parameters: [
            "name" : name,
            "phone" : phone,
            "email" : email], encoding: JSONEncoding.default)
        }
    }

    var headers: [String: String]? {
        return ["Content-type": "application/json; charset=utf-8"]
    }
}

