//
//  LaboratoryModel.swift
//  Pharmacy
//
//  Created by Anna Yatsun on 18.02.2021.
//  Copyright © 2021 pharmacy. All rights reserved.
//

import Foundation

struct LaboratoryResearchModel: Codable {
    
    var laboratoryName: String?
    
    enum Keys: String, CodingKey {
        case laboratoryName
    }
    
    init(laboratoryName: String) {
        self.laboratoryName = laboratoryName
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)

        laboratoryName = try? container.decode(String.self, forKey: .laboratoryName)
    }
}
