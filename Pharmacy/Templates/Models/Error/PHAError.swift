//
//  PHAError.swift
//  Pharmacy
//
//  Created by Daniiar Erkinov on 2/8/21.
//  Copyright © 2021 pharmacy. All rights reserved.
//

import Foundation

enum PHAError: LocalizedError {
    case responseError(message: String)
    case decodeFailed(message: String)
}

extension PHAError {
    var errorDescription: String? {
        switch self {
        case .responseError(let message):
            return message
        case .decodeFailed(let message):
            return "Failed to decode. \n \(message)"
        }
    }
}
