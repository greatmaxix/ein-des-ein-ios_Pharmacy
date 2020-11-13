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
}

extension ReceiptsAPI: RequestConvertible {

    var path: String {
        switch self {
        case .loadReceipts:
            return "customer/recipes"
        }
    }

    var method: Moya.Method {
        switch self {
        case .loadReceipts:
            return .get
        }
    }

    var task: Task {
        switch self {
        case .loadReceipts:
            return .requestPlain
        }
    }
}
