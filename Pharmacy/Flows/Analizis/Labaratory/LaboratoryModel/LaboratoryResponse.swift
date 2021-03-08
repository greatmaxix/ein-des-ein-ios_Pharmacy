//
//  File.swift
//  Pharmacy
//
//  Created by Anna Yatsun on 18.02.2021.
//  Copyright © 2021 pharmacy. All rights reserved.
//

import Foundation


struct LaboratoryResponse: Codable {
    var laboratory: [LaboratoryResearchModel]

    enum Keys: String, CodingKey {
        case laboratory
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)

        laboratory = try container.decode([LaboratoryResearchModel].self, forKey: .laboratory)
    }
}
