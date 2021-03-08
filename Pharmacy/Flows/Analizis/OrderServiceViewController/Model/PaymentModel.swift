//
//  PaymentModel.swift
//  Pharmacy
//
//  Created by Anna Yatsun on 03.03.2021.
//  Copyright © 2021 pharmacy. All rights reserved.
//

import Foundation

struct PaymentModel: Codable {
    
    var paymetText: String?
    var paymetImage: String?
    
    enum Keys: String, CodingKey {
        case paymetText
        case paymetImage
    }
    
    init(paymetText: String, paymetImage: String) {
        self.paymetText = paymetText
        self.paymetImage = paymetImage
        
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)

        paymetText = try? container.decode(String.self, forKey: .paymetText)

        paymetImage = try? container.decode(String.self, forKey: .paymetImage)
    }
}
