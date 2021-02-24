//
//  etailLaboratoryModel.swift
//  Pharmacy
//
//  Created by Anna Yatsun on 19.02.2021.
//  Copyright © 2021 pharmacy. All rights reserved.
//

import Foundation

struct LaboratoryDetailModel: Codable {
    var analisName: String?
    var countOfDay: String?
    
    enum Keys: String, CodingKey {
        case analisName
        case countOfDay
    }
    
    init(analisName: String, countOfDay: String ) {
        self.analisName = analisName
        self.countOfDay = countOfDay
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)

        analisName = try? container.decode(String.self, forKey: .analisName)
        countOfDay = try? container.decode(String.self, forKey: .countOfDay)
    }
}
