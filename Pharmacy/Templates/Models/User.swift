//
//  User.swift
//  Pharmacy
//
//  Created by CGI-Kite on 02.07.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation

struct User: Equatable, Codable {
    
    enum CodingKeys: String, CodingKey {
        
        case name = "username"
        case uuid
        case phone
        case email
    }
    
    let name: String
    let email: String?
    let phone: String
    let uuid: String
}
