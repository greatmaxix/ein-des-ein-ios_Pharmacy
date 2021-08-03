//
//  PharmacyErrorResponse.swift
//  Pharmacy
//
//  Created by Daniiar Erkinov on 2/8/21.
//  Copyright © 2021 pharmacy. All rights reserved.
//

import Foundation

struct PharmacyErrorResponse: Decodable {
    let status: String
    let message: String?
    let errorType: String?
    
    enum CodingKeys: String, CodingKey {
        case status
        case message
        case errorType = "error_type"
    }
    
    var unwrappedErrorType: String {
        return errorType ?? ""
    }
    
    var unwrappedErrorMessage: String {
        return message ?? ""
    }
    
    var errorFullMessage: String {
        return "\(unwrappedErrorType):\n\(unwrappedErrorMessage)"
    }
}
