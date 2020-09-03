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
    
    
}

// MARK: - Entity
extension UserEntity: Entity {

    public static var primaryKey: String {
        return #keyPath(identifier)
    }
}
