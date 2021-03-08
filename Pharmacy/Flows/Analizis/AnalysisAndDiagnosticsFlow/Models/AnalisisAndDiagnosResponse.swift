//
//  TypeOfAnalys.swift
//  Pharmacy
//
//  Created by Anna Yatsun on 18.02.2021.
//  Copyright © 2021 pharmacy. All rights reserved.
//

import Foundation

struct AnalisisAndDiagnosResponse: Codable {
    var item: [TypeOfAnalysis]

    enum Keys: String, CodingKey {
        case item
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)

        item = try container.decode([TypeOfAnalysis].self, forKey: .item)
    }
}
