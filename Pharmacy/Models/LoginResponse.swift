//
//  LoginResponseModel.swift
//  Pharmacy
//
//  Created by CGI-Kite on 23.06.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation

struct LoginResponse: Equatable, Codable {
    var token: String
    
    enum CodingKeys: String, CodingKey {
        case token
    }
}
