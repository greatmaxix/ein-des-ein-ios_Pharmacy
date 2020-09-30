//
//  SearchAPI.swift
//  Pharmacy
//
//  Created by Sapa Denys on 08.09.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Moya

enum SearchAPI: RequestConvertible {
    
    case searchByName(name: String,
        regionId: Int,
        categoryCode: String? = nil,
        pageNumber: Int = 1,
        itemsOnPage: Int = 10)
    case searchByBarCode(barCode: String,
        regionId: Int,
        categoryCode: String? = nil,
        pageNumber: Int = 1,
        itemsOnPage: Int = 10)
    
    var path: String {
        switch self {
        case .searchByName,
             .searchByBarCode:
            return "public/products/search"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .searchByName,
             .searchByBarCode:
            return .get
        }
    }
    
    var task: Task {
        let params: [String: Any?]
        switch self {
        case .searchByName(let name, let regionId, let categoryCode, let pageNumber, let itemsOnPage):
            params = [.nameKey: name,
                      .regionIdKey: regionId,
                      .categoryCode: categoryCode,
                      .pageKey: pageNumber,
                      .perPageKey: itemsOnPage]
            
        case .searchByBarCode(let barCode, let regionId, let categoryCode, let pageNumber, let itemsOnPage):
            params = [.barCodeKey: barCode,
                      .regionIdKey: regionId,
                      .categoryCode: categoryCode,
                      .pageKey: pageNumber,
                      .perPageKey: itemsOnPage]
        }
        
        return .requestParameters(parameters: params.compactMapValues { $0 },
                                  encoding: URLEncoding.queryString)
    }
}

// MARK: - Query Keys
private extension String {
    static let nameKey: String = "name"
    static let barCodeKey: String = "barCode"
    static let regionIdKey: String = "regionId"
    static let categoryCode: String = "categoryCode"
    static let pageKey: String = "page"
    static let perPageKey: String = "per_page"
}
