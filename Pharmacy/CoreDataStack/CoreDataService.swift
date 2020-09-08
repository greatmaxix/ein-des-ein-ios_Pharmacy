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
        NSPersistentContainer.loadPersistentStores()
        viewContext = NSPersistentContainer.container.viewContext
    }
    
    func renewingCoreData() {
        NSPersistentContainer.deletePersistentStores { [weak self] in
            self?.setup()
        }
    }
    
    func get<ResultType: FetchResultObject & Entity>(by id: Int) -> ResultType? {
        guard let object: ResultType = try? viewContext.first(withPrimaryKey: Int64(id)) else {
            return nil
        }
        
        return object
    }
    
    func save(user dto: UserDTO) {
        let predicate = NSPredicate(format: "\(dto.entityType.primaryKey) = %@", dto.identifier)
        
        dto.entityType.createOrUpdate(in: viewContext,
                                      matching: predicate) { [unowned self] entity in
                                        dto.fillEntity(entity: entity)
                                        
                                        guard let avatarDTO = dto.avatar else {
                                            return
                                        }
                                        
                                        self.save(avatar: avatarDTO, isNeedToSave: false)
                                        
                                        bindAvatarToUser(andSave: false)

        }
        
        try? viewContext.saveIfNeeded()
    }
    
    func save(avatar dto: AvatarDTO, isNeedToSave: Bool = true) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: dto.entityType.entityName)
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        _ = try? viewContext.execute(batchDeleteRequest)
        
        let predicate = NSPredicate(format: "\(dto.entityType.primaryKey) = %@", dto.identifier)
        dto.entityType.createOrUpdate(in: self.viewContext,
                                            matching: predicate) {
                                                dto.fillEntity(entity: $0)
        }
        
        if isNeedToSave {
            try? viewContext.saveIfNeeded()
        }
        
    }
    
    func bindAvatarToUser(andSave isNeedToSave: Bool = true) {
        let users: [UserEntity] = (try? viewContext.all()) ?? []
        let avatars: [AvatarEntity] = (try? viewContext.all())  ?? []
        
        guard let user = users.first,
            let avatar = avatars.first else {
                return
        }
        
        user.uppdate(avatar: avatar)
        
        if isNeedToSave {
            try? viewContext.saveIfNeeded()
        }
    }
}
