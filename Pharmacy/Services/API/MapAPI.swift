//
//  MapAPI.swift
//  Pharmacy
//
//  Created by CGI-Kite on 14.09.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import Moya

enum MapAPI {
    
    case getPharmacies(medicineId: Int, regionId: Int, page: Int, pageCount: Int)
}

extension MapAPI: RequestConvertible {
    
    var path: String {
        switch self {
        case  .getPharmacies(medicineId: let id, regionId: _, page: _, pageCount: _):
            return "public/pharmacies/global-product/\(id)/pharmacy-products"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case  .getPharmacies:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getPharmacies(medicineId: _, regionId: let regionId, page: let pageNumber, pageCount: let pageCount):
            return .requestParameters(parameters: [Keys.region: regionId, Keys.pageNumber: pageNumber, Keys.pages: pageCount], encoding: URLEncoding.default)
        }
    }
    
    private struct Keys {
        static let region: String = "regionId"
        static let pageNumber: String = "page"
        static let pages: String = "per_page"
    }
}
