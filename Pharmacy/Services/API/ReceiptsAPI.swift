//
//  ReceiptsAPI.swift
//  Pharmacy
//
//  Created by Mikhail Timoscenko on 13.11.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import Moya

enum ReceiptsAPI {
    case loadReceipts
    case getPDF(code: String)
}

extension ReceiptsAPI: RequestConvertible {

    var path: String {
        switch self {
        case .loadReceipts:
            return "customer/recipes"
        case .getPDF(let code):
            return "recipe/file/\(code)"
        }
    }

    var method: Moya.Method {
        switch self {
        case .loadReceipts:
            return .get
        case .getPDF:
            return .get
        }
    }

    var task: Task {
        switch self {
        case .loadReceipts:
            return .requestPlain
        case .getPDF:
            return .requestPlain
        }
    }
}
