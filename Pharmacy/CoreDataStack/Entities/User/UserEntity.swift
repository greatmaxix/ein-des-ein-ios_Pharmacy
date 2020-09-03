//
//  UserEntity.swift
//  Pharmacy
//
//  Created by Sapa Denys on 03.09.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import CoreData

@objc(UserEntity)
final class UserEntity: NSManagedObject {

    // MARK: - Properties
    @NSManaged public private(set) var identifier: Int64
    @NSManaged public private(set) var name: String
    @NSManaged public private(set) var email: String?
    @NSManaged public private(set) var phone: String
    
    func updateWith(_ dto: User) {
        identifier = Int64(dto.id)
        name = dto.name
        email = dto.email
        phone = dto.phone
    }
}

// MARK: - Entity
extension UserEntity: Entity {

    public static var primaryKey: String {
        return #keyPath(identifier)
    }
}
