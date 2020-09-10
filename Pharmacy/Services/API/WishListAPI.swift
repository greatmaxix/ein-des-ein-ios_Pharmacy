//
//  WishListAPI.swift
//  Pharmacy
//
//  Created by CGI-Kite on 03.09.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import Moya

enum WishListAPI {
    
    case addToWishList(medicineId: String)
    case removeFromWishList(medicineId: String)
    case getWishList(pageNumber: Int, medicinesPerPage: Int)
}

extension WishListAPI: RequestConvertible {
    
    var path: String {
        switch self {
        case .addToWishList(let id), .removeFromWishList(let id):
            return "customer/wishlist/global-product/" + id
        case .getWishList:
            return "customer/wishlist"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .addToWishList:
            return .post
        case .removeFromWishList:
            return .delete
        case .getWishList:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .addToWishList:
            return .requestPlain//.requestParameters(parameters: ["id": id], encoding: JSONEncoding.default)
        case .removeFromWishList(let id):
            return .requestParameters(parameters: ["id": id], encoding: JSONEncoding.default)
        case .getWishList(let pageNumber, let medicinesPerPage):
            return .requestParameters(parameters: ["page": pageNumber, "per_page": medicinesPerPage], encoding: URLEncoding.default)
        }
    }
    
}
