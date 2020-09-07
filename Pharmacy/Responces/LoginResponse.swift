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
    var refreshToken: String
    var user: UserDTO
    
    enum CodingKeys: String, CodingKey {
        case user = "item"
        case token
        case refreshToken
    }
}
