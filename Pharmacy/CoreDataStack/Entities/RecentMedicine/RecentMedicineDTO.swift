//
//  RecentMedicineDTO.swift
//  Pharmacy
//
//  Created by Sergey berdnik on 27.10.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation

struct RecentMedicineDTO: Equatable, Codable {
    let productId: Int
    let liked: Bool
    let minPrice: Double
    let maxPrice: Double
    let name: String
    let releaseForm: String
    let picture: String
}

extension RecentMedicineDTO: Storable {
    
    var entityType: RecentMedicineEntity.Type {
        RecentMedicineEntity.self
    }
    
    var identifier: NSObject {
        NSNumber(value: productId)
    }
    
    func fillEntity(entity: RecentMedicineEntity) {
        entity.updateWith(self)
    }
}
