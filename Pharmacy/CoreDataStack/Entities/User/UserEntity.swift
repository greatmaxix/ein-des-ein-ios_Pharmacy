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
    @NSManaged public private(set) var topicName: String?
    @NSManaged public private(set) var email: String?
    @NSManaged public private(set) var phone: String
    @NSManaged public private(set) var uuid: String
    @NSManaged public private(set) var avatar: AvatarEntity?
    @NSManaged public private(set) var region: RegionEntity?
    @NSManaged public private(set) var deliveryAdress: DeliveryAddressEntity?
    
    // MARK: - Public methods
    func updateWith(_ dto: UserDTO) {
        identifier = Int64(dto.id)
        name = dto.name
        email = dto.email
        phone = dto.phone
        topicName = dto.topicName
        uuid = dto.uuid
    }
    
    func uppdate(avatar: AvatarEntity?) {
        self.avatar = avatar
    }
    
    func uppdate(region: RegionEntity?) {
        self.region = region
    }
    
    func uppdate(address: DeliveryAddressEntity?) {
        self.deliveryAdress = address
    }
}

// MARK: - Entity
extension UserEntity: Entity {

    public static var primaryKey: String {
        return #keyPath(identifier)
    }
}
