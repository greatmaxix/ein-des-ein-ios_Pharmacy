//
//  User.swift
//  Pharmacy
//
//  Created by CGI-Kite on 02.07.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation

protocol Storable where ManagedObject: Managed {
    associatedtype ManagedObject
    
    var entityType: ManagedObject.Type { get }
    var identifier: NSObject { get }
    func fillEntity(entity: ManagedObject)
}

struct User: Equatable, Codable, Identifiable {
    let id: UInt64
    let name: String
    let email: String?
    let phone: String
    let uuid: String
    var avatar: Avatar?
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

struct Avatar: Equatable, Codable {
    let url: URL
    let uuid: String?
}
