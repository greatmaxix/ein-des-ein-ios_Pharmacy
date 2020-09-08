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
        pageNumber: Int = 0,
        itemsOnPage: Int = 10)
    case searchByBarCode(barCode: String,
        regionId: Int,
        pageNumber: Int = 0,
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
        switch self {
        case .searchByName(let name, let regionId, let pageNumber, let itemsOnPage):
            return .requestParameters(parameters: [.nameKey: name,
                                                   .regionIdKey: regionId,
                                                   .pageKey: pageNumber,
                                                   .perPageKey: itemsOnPage],
                                      encoding: URLEncoding.queryString)
        case .searchByBarCode(let barCode, let regionId, let pageNumber, let itemsOnPage):
            return .requestParameters(parameters: [.barCodeKey: barCode,
                                                   .regionIdKey: regionId,
                                                   .pageKey: pageNumber,
                                                   .perPageKey: itemsOnPage],
                                      encoding: URLEncoding.queryString)
        }
    }
}

// MARK: - Query Keys
private extension String {
    static let nameKey: String = "name"
    static let barCodeKey: String = "barCode"
    static let regionIdKey: String = "regionId"
    static let pageKey: String = "page"
    static let perPageKey: String = "per_page"
}
