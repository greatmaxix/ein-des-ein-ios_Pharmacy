//
//  Entity.swift
//  Pharmacy
//
//  Created by Sapa Denys on 03.09.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import CoreData

public protocol Entity: AnyObject {
    static var primaryKey: String { get }
}

extension Entity where Self: NSManagedObject {
    
    static func findOrCreate(in context: NSManagedObjectContext,
                             matching predicate: NSPredicate,
                             configure: (Self) -> Void) -> Self {
        let fetchedObject = fetch(in: context) { request in
            request.predicate = predicate
            request.returnsObjectsAsFaults = false
            request.fetchLimit = 1
        }.first
        guard let object = fetchedObject else {
            let newObject: Self = context.insertObject()
            configure(newObject)
            return newObject
        }
        return object
    }
    
    static func fetch(in context: NSManagedObjectContext,
                      configurationBlock: (NSFetchRequest<Self>) -> Void = { _ in }) -> [Self] {
        let request = NSFetchRequest<Self>(entityName: Self.entityName)
        configurationBlock(request)
        return (try? context.fetch(request)) ?? []
    }
}
