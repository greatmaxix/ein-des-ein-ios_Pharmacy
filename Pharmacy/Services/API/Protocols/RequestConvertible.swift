//
//  RequestConvertible.swift
//  Pharmacy
//
//  Created by Sapa Denys on 08.09.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Moya

protocol RequestConvertible: TargetType, AccessTokenAuthorizable {
    func host() -> URL
}

// MARK: - Default implementation
extension RequestConvertible {
    
    func host() -> URL {
        let infoDictionary = Bundle.main.infoDictionary
        guard let URLString = infoDictionary?[.APIHost] as? String,
            let host = URL(string: URLString) else {
                fatalError("Can't get API Host during making RequestConvertible request")
        }

        return host
    }
    
    var sampleData: Data {
        Data()
    }
    
    var baseURL: URL {
        host()
    }
    
    var authorizationType: AuthorizationType? {
        .bearer
    }
    
    var headers: [String: String]? {
        switch self {
        default:
            return ["Content-type": "application/json"]
        }
    }
}

private extension String {
    static let APIHost: String = "APIHost"
}
