//
//  RegionEntity.swift
//  Pharmacy
//
//  Created by Sergey berdnik on 30.10.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import CoreData

@objc(RegionEntity)
final class RegionEntity: NSManagedObject {

    // MARK: - Properties
    @NSManaged public private(set) var id: Int64
    @NSManaged public private(set) var name: String
    
    // MARK: - Public methods
    func updateWith(_ dto: RegionDTO) {
        id = dto.id
        name = dto.name
    }
}

// MARK: - Entity
extension RegionEntity: Entity {

    public static var primaryKey: String {
        return #keyPath(id)
    }
}
