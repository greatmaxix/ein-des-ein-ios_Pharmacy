//
//  DeliveryAddressEntity.swift
//  Pharmacy
//
//  Created by Sergey berdnik on 02.11.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import CoreData

@objc(DeliveryAddressEntity)
final class DeliveryAddressEntity: NSManagedObject {

    // MARK: - Properties
    @NSManaged public private(set) var city: String
    @NSManaged public private(set) var street: String
    @NSManaged public private(set) var house: String
    @NSManaged public private(set) var pavilion: String
    @NSManaged public private(set) var flat: String
    @NSManaged public private(set) var note: String
    
    // MARK: - Public methods
    func updateWith(_ dto: DeliveryAddressDTO) {
        city = dto.city
        street = dto.street
        house = dto.house
        pavilion = dto.pavilion ?? ""
        flat = dto.flat ?? ""
        note = dto.note ?? ""
    }
}

// MARK: - Entity
extension DeliveryAddressEntity: Entity {

    public static var primaryKey: String {
        return #keyPath(street)
    }
}
