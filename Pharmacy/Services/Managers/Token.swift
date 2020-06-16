//
//  Token.swift
//  Pharmacy
//
//  Created by Mikhail Timoscenko on 16.06.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation

struct Tokens: Equatable, Codable {
    enum CodingKeys: String, CodingKey {
        case bearer = "access_token"
    }

    let bearer: String?
}
