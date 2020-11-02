//
//  DeliveryAddressDTO.swift
//  Pharmacy
//
//  Created by Sergey berdnik on 02.11.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation

struct DeliveryAddressDTO: Equatable, Codable {
    let city: String
    let street: String
    let house: String
    let pavilion: String?
    let flat: String?
    let note: String?
}

extension DeliveryAddressDTO: Storable {
    
    var entityType: DeliveryAddressEntity.Type {
        DeliveryAddressEntity.self
    }
    
    var identifier: NSObject {
        NSString(string: street)
    }
    
    func fillEntity(entity: DeliveryAddressEntity) {
        entity.updateWith(self)
    }
}
