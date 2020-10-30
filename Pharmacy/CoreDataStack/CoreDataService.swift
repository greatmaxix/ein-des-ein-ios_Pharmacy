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
    
    func getRecentMedicine() -> [RecentMedicineDTO]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: RecentMedicineEntity.entityName)
        guard let data = try? viewContext.fetch(fetchRequest) as? [RecentMedicineEntity] else {
            return nil}
        
        var result: [RecentMedicineDTO] = []
        data.forEach {result.append(RecentMedicineDTO.init(productId: $0.productId,
                                                           liked: $0.liked,
                                                           minPrice: $0.minPrice,
                                                           maxPrice: $0.maxPrice,
                                                           name: $0.name,
                                                           releaseForm: $0.releaseForm,
                                                           imageURL: $0.imageURL))
            }

        return result
        }
    
    func save(user dto: UserDTO) {
        let predicate = NSPredicate(format: "\(dto.entityType.primaryKey) = %@", dto.identifier)
        
        dto.entityType.createOrUpdate(in: viewContext,
                                      matching: predicate) { [unowned self] entity in
                                        dto.fillEntity(entity: entity)
                                        
        guard let avatarDTO = dto.avatar else { return }
                                        
                                        self.save(avatar: avatarDTO, isNeedToSave: false)
        
            if let regionDTO = dto.region{
                self.save(region: regionDTO, isNeedToSave: false)
                bindRegionToUser(andSave: false)
            }
                                    
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
    
    func save(region dto: RegionDTO, isNeedToSave: Bool = true) {
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
    
    func save(medicine dto: RecentMedicineDTO) {
        
        let predicate = NSPredicate(format: "\(dto.entityType.primaryKey) = %@", dto.identifier)
        
        dto.entityType.createOrUpdate(in: self.viewContext,
                                            matching: predicate) {
                                                dto.fillEntity(entity: $0)
        }
        
        try? viewContext.save()
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
    
    func bindRegionToUser(andSave isNeedToSave: Bool = true) {
        let users: [UserEntity] = (try? viewContext.all()) ?? []
        let region: RegionEntity? = (try? viewContext.all().first) ?? nil
        
        guard let user = users.first,
            let reg = region else {
                return
        }
        
        user.uppdate(region: reg)
        
        if isNeedToSave {
            try? viewContext.saveIfNeeded()
        }
    }
}
