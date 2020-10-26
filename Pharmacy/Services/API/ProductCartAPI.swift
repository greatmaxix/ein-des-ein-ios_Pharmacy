//
//  ProductCartAPI.swift
//  Pharmacy
//
//  Created by Sergey berdnik on 26.10.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import Moya

enum ProductCartAPI {
    
    case addPharmacyToCart(medicineId: Int)
}

extension ProductCartAPI: RequestConvertible {
    
    var path: String {
        switch self {
        case .addPharmacyToCart(let id):
            return "/api/v1/customer/product-cart/pharmacy-product/\(id)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .addPharmacyToCart:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .addPharmacyToCart:
            return .requestPlain
    }
 }
}
