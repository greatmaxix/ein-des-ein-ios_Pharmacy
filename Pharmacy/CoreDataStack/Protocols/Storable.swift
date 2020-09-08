//
//  Storable.swift
//  Pharmacy
//
//  Created by Sapa Denys on 03.09.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation

protocol Storable where ManagedObject: Managed {
    associatedtype ManagedObject
    
    var entityType: ManagedObject.Type { get }
    var identifier: NSObject { get }
    func fillEntity(entity: ManagedObject)
}
