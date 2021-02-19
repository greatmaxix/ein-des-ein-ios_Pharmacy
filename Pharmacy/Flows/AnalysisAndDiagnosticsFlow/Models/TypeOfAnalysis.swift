//
//  TypeOfAnalysis.swift
//  Pharmacy
//
//  Created by Anna Yatsun on 18.02.2021.
//  Copyright © 2021 pharmacy. All rights reserved.
//

import Foundation

struct TypeOfAnalysis: Codable {
    
    var analisName: String?
    
    enum Keys: String, CodingKey {
        case analisName
    }
    
    init(analisName: String) {
        self.analisName = analisName
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)

        analisName = try? container.decode(String.self, forKey: .analisName)
    }
}
