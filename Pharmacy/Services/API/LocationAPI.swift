//
//  LocationAPI.swift
//  Pharmacy
//
//  Created by CGI-Kite on 04.09.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import Moya

enum LocationAPI {
    
    case getRegions(regionId: String, maxLevelCount: String)
    case getCountries(page: Int, countriesPerPage: Int)
}

extension LocationAPI: TargetType, AccessTokenAuthorizable {
    
    var sampleData: Data {
        return Data()
    }
    
    var authorizationType: AuthorizationType? {
        return .bearer
    }
    
    var baseURL: URL {
        return URL(string: "https://api.pharmacies.fmc-dev.com/api/v1/public")!
    }
    
    var path: String {
        switch self {
        case .getCountries:
            return "countries"
        case .getRegions:
            return "regions"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Task {
        switch self {

        case .getCountries(page: let page, countriesPerPage: let countriesPerPage):
            return .requestParameters(parameters: ["page": page, "per_page": countriesPerPage], encoding: URLEncoding.default)
        case .getRegions(regionId: let id, maxLevelCount: let count):
            return .requestParameters(parameters: ["id": id, "maxLevelCount": count], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        default:
            return ["Content-type": "application/json"]
        }
    }
}
