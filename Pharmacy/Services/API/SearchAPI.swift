//
//  SearchAPI.swift
//  Pharmacy
//
//  Created by Sapa Denys on 08.09.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import Moya

enum SearchAPI: TargetType, AccessTokenAuthorizable {
    case search
}

extension SearchAPI {
    
    var sampleData: Data {
        return Data()
    }
    
    var authorizationType: AuthorizationType? {
        return .bearer
    }
    
    var baseURL: URL {
        return URL(string: "https://api.pharmacies.fmc-dev.com/api/v1/customer")!
    }
    
    var path: String {
        switch self {
        case .search:
            return "products/search"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .search:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .search:
            return .requestParameters(parameters: ["": ""], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        default:
            return ["Content-type": "application/json"]
        }
    }
}
