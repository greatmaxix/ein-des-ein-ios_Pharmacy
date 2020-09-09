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
    
    case getRegions(regionId: String?, maxLevelCount: Int?)
    case getCountries(page: Int, countriesPerPage: Int)
}

extension LocationAPI: RequestConvertible {
    
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
            return Keys.countries
        case .getRegions:
            return Keys.regions
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Task {
        switch self {

        case .getCountries(page: let page, countriesPerPage: let countriesPerPage):
            return .requestParameters(parameters: [Keys.page: page, Keys.perPage: countriesPerPage], encoding: URLEncoding.default)
        case .getRegions(regionId: let id, maxLevelCount: let count):
            let defaultKazCode = "1"
            let regionId = id ?? defaultKazCode
            var params: [String: Any] =  [Keys.id: regionId]
            if let count = count {
                params[Keys.level] = count
            }
            
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        default:
            return ["Content-type": "application/json"]
        }
    }
    
    private struct Keys {
        static let countries: String = "countries"
        static let regions: String = "regions"
        static let id: String = "id"
        static let page: String = "page"
        static let perPage: String = "page"
        static let level: String = "maxLevelCount"
    }
}
