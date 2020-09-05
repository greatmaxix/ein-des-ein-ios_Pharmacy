//
//  NSPersistentContainer.swift
//  Pharmacy
//
//  Created by Sapa Denys on 03.09.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import CoreData

extension NSPersistentContainer {

    // MARK: - Static properties
    private static let dataModelName = "Pharmacy"
    private static let pharmacyContainer = NSPersistentContainer(name: dataModelName)

    public static let container: NSPersistentContainer = {
        let semaphore = DispatchSemaphore(value: 0)
        pharmacyContainer.loadPersistentStores { _, store in
            if let existingStore = store {
                fatalError("Failed to load store: \(existingStore)")
            }
            semaphore.signal()
        }
        semaphore.wait()

        let path = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true)
        print("SQLite file path: \(path)")

        return pharmacyContainer
    }()

    public static let backgroundContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = container.viewContext
        container.viewContext.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

        return context
    }()

    // MARK: - Public methods
    public static func newBackgroundContext() -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = NSPersistentContainer.backgroundContext
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

        return context
    }
}
