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

        data.forEach {
            result.append(RecentMedicineDTO.init(productId: $0.productId,
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
                                        
            if let avatarDTO = dto.avatar {
            self.save(avatar: avatarDTO, isNeedToSave: false)
            bindAvatarToUser(andSave: false)
            }
                                        
            if let regionDTO = dto.region {
                self.save(region: regionDTO, isNeedToSave: false)
                bindRegionToUser(andSave: false)
            }
            
            if let deliveryAddress = dto.deliveryAddress {
                self.save(address: deliveryAddress, isNeedToSave: false)
                bindDeliveryAddressToUser(andSave: false)
            }
                                
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
    
    func save(address dto: DeliveryAddressDTO, isNeedToSave: Bool = true) {
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
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: dto.entityType.entityName)
        
        if let data = try? viewContext.fetch(fetchRequest) as? [RecentMedicineEntity],
           let item = data.last {
            
            let medicine = RecentMedicineDTO.init(productId: item.productId, liked: item.liked, minPrice: item.minPrice, maxPrice: item.maxPrice, name: item.name, releaseForm: item.releaseForm, imageURL: item.imageURL)
            
                savePreviousMedicineViewed(item: medicine)
        }
        
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
    
    func bindDeliveryAddressToUser(andSave isNeedToSave: Bool = true) {
        let users: [UserEntity] = (try? viewContext.all()) ?? []
        let deliveryAdress: DeliveryAddressEntity? = (try? viewContext.all().first) ?? nil
        
        guard let user = users.first,
            let adress = deliveryAdress else {
                return
        }
        
        user.uppdate(address: adress)
        try? viewContext.saveIfNeeded()
    }
}

private extension CoreDataService {
    /**
        Save prevous viewed medicine. Used this func only with saving current viewing medicine. This func save two viewed medicint elements and remove others from coreData
     
     - Parameter item: enter last item from data in viewContext.fetch(NSFetchRequest) as        [RecentMedicineEntity]
     */
    func savePreviousMedicineViewed(item: RecentMedicineDTO) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: item.entityType.entityName)
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        _ = try? viewContext.execute(batchDeleteRequest)
        
        let previousPredicate = NSPredicate(format: "\(item.entityType.primaryKey) = %@", item.identifier)
        
        item.entityType.createOrUpdate(in: self.viewContext,
                                                matching: previousPredicate) {
        item.fillEntity(entity: $0)
    }
  }
}
