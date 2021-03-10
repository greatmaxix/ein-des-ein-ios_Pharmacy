//
//  ChoseClinicAPI.swift
//  Pharmacy
//
//  Created by Anna Yatsun on 01.03.2021.
//  Copyright © 2021 pharmacy. All rights reserved.
//

import Foundation

import Foundation
import Moya

enum ChoseClinicAPI {
    case getClinicLict
}

extension ChoseClinicAPI: RequestConvertible {
    var path: String {
        switch  self {
        case .getClinicLict:
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getClinicLict:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getClinicLict:
            return .requestPlain
        }
    }
}
