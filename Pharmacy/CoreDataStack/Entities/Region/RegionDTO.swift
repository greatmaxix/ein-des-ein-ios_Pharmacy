//
//  RegionDTO.swift
//  Pharmacy
//
//  Created by Sergey berdnik on 30.10.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation

struct RegionDTO: Equatable, Codable {
    let id: Int64
    let name: String
}

extension RegionDTO: Storable {
    
    var entityType: RegionEntity.Type {
        RegionEntity.self
    }
    
    var identifier: NSObject {
        NSNumber(value: id)
    }
    
    func fillEntity(entity: RegionEntity) {
        entity.updateWith(self)
    }
}
