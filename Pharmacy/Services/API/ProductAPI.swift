//
//  ProductAPI.swift
//  Pharmacy
//
//  Created by Sapa Denys on 02.10.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Moya

enum ProductAPI: RequestConvertible {
    case global(identifier: Int)
    
    var path: String {
        switch self {
        case .global(let identifier):
            return "public/products/global-product/\(identifier)"
        }
    }
    
    var method: Method {
        switch self {
        case .global:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .global:
            return .requestPlain
        }
    }
}
