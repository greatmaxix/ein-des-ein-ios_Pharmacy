//
//  AvatarEntity.swift
//  Pharmacy
//
//  Created by Sapa Denys on 03.09.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import CoreData

@objc(AvatarEntity)
final class AvatarEntity: NSManagedObject {

    // MARK: - Properties
    @NSManaged public private(set) var uuid: String
    @NSManaged private var primitiveUrl: String
    
    public private(set) var url: URL {
        get {
            defer {
                didAccessValue(forKey: "url")
            }
            willAccessValue(forKey: "url")
            
            guard let url = URL(string: primitiveUrl) else {
                fatalError("Can not convert stored url: \(primitiveUrl) to \(URL.self)")
            }
            
            return url
        }
        set {
            willChangeValue(forKey: "url")
            primitiveUrl = newValue.absoluteString
            didChangeValue(forKey: "url")
        }
    }
    
    // MARK: - Public methods
    func updateWith(_ dto: AvatarDTO) {
        uuid = dto.uuid
        url = dto.url
    }
}

// MARK: - Entity
extension AvatarEntity: Entity {

    public static var primaryKey: String {
        return #keyPath(uuid)
    }
}
