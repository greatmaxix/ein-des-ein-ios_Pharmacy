//
//  User.swift
//  Pharmacy
//
//  Created by CGI-Kite on 02.07.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation

struct User: Equatable, Codable, Identifiable {
    let id: UInt64
    let name: String
    let email: String?
    let phone: String
    let uuid: String
    var avatar: AvatarDTO?
}

extension User: Storable {
    
    var entityType: UserEntity.Type {
        UserEntity.self
    }
    
    var identifier: NSObject {
        NSNumber(value: id)
    }
    
    func fillEntity(entity: UserEntity) {
        entity.updateWith(self)
    }
}
