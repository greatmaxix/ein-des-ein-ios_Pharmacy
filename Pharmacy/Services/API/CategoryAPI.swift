//
//  CategoryAPI.swift
//  Pharmacy
//
//  Created by CGI-Kite on 02.09.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import Moya

enum CategoryAPI {
    
    case getCategories(startCode: String?, maxLevel: Int?)
}

extension CategoryAPI: RequestConvertible {
    
    var path: String {
        switch self {
        case .getCategories:
            return "public/categories"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getCategories:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getCategories(startCode: let startCode, maxLevel: let maxLevel):
            if let startCode = startCode, let maxLevel = maxLevel {
                return .requestParameters(parameters: ["startCode": startCode, "maxLevelCount": maxLevel], encoding: URLEncoding.default)
            }
            return .requestPlain
        }
    }
}
