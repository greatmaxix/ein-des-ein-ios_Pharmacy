//
//  File.swift
//  Pharmacy
//
//  Created by Anna Yatsun on 18.02.2021.
//  Copyright © 2021 pharmacy. All rights reserved.
//

import Foundation
import Moya

enum LaboratoryListAPI {
    case getLaboratoryList
}

extension LaboratoryListAPI: RequestConvertible {
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
