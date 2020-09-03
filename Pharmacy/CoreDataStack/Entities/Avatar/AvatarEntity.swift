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

    @NSManaged public private(set) var uuid: String?
    @NSManaged private var primitiveUrl: String?
    
    public private(set) var url: URL? {
        get {
            defer {
                didAccessValue(forKey: "url")
            }
            willAccessValue(forKey: "url")

            guard let stringURL = primitiveUrl else {
                return nil
            }
            
            return URL(string: stringURL)
        }
        set {
            willChangeValue(forKey: "url")
            primitiveUrl = newValue?.absoluteString
            didChangeValue(forKey: "url")
        }
    }
}
