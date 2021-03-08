//
//  DeteilLaboratorAPI.swift
//  Pharmacy
//
//  Created by Anna Yatsun on 22.02.2021.
//  Copyright © 2021 pharmacy. All rights reserved.
//

import Foundation
import Moya

enum DeteilLaboratorAPI {
    case getLaboratoryList
}

extension DeteilLaboratorAPI: RequestConvertible {
    var path: String {
        switch  self {
        case .getLaboratoryList:
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getLaboratoryList:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getLaboratoryList:
            return .requestPlain
        }
    }
}
