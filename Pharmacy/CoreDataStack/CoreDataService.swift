//
//  CoreDataService.swift
//  Pharmacy
//
//  Created by Sapa Denys on 03.09.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import CoreData

final class CoreDataService {

    // MARK: - Static properties
    static let shared = CoreDataService()
    
    // MARK: - Properties
    private var viewContext: NSManagedObjectContext!
    
    // MARK: - Public methods
    func setup() {
        let container = NSPersistentContainer.container
        viewContext = container.viewContext
    }
    
    func get<ResultType: FetchResultObject & Entity>(by id: UInt64) -> ResultType? {
        guard let object: ResultType = try? viewContext.first(withPrimaryKey: id) else {
            return nil
        }
        
        return object
    }
    
    func save<DTO: Storable>(_ dto: DTO) {
        let predicate = NSPredicate(format: "\(dto.entityType.primaryKey) = %@", dto.identifier)
        
        dto.entityType.createOrUpdate(in: viewContext,
                                      matching: predicate) { entity in
                                        dto.fillEntity(entity: entity)
        }
        
        try? viewContext.saveIfNeeded()
    }
}
