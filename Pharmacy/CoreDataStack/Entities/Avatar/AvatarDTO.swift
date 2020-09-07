//
//  AvatarDTO.swift
//  Pharmacy
//
//  Created by Sapa Denys on 03.09.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation

struct AvatarDTO: Equatable, Codable {
    let url: URL
    let uuid: String
}

extension AvatarDTO: Storable {
    
    var entityType: AvatarEntity.Type {
        AvatarEntity.self
    }
    
    var identifier: NSObject {
        NSString(string: uuid)
    }
    
    func fillEntity(entity: AvatarEntity) {
        entity.updateWith(self)
    }
}
