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
    
    case getCategories(id: Int?, maxLevel: Int?)
}

extension CategoryAPI: RequestConvertible {
    
    var path: String {
        switch self {
        case .getCategories:
            return "public/new-categories"
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
        case .getCategories(id: let id, maxLevel: let maxLevel):
            if let id = id, let maxLevel = maxLevel {
                return .requestParameters(parameters: ["id": id, "maxLevelCount": maxLevel], encoding: URLEncoding.default)
            }
            return .requestPlain
        }
    }
}
