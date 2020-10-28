//
//  RecentMedicineEntity.swift
//  Pharmacy
//
//  Created by Sergey berdnik on 27.10.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import CoreData

@objc(RecentMedicineEntity)
final class RecentMedicineEntity: NSManagedObject {

    // MARK: - Properties
    @NSManaged public private(set) var productId: Int
    @NSManaged public private(set) var name: String
    @NSManaged public private(set) var liked: Bool
    @NSManaged public private(set) var minPrice: Double
    @NSManaged public private(set) var maxPrice: Double
    @NSManaged public private(set) var releaseForm: String
    @NSManaged public private(set) var picture: String
    
// MARK: - Public methods
    func updateWith(_ dto: RecentMedicineDTO) {
        productId = dto.productId
        name = dto.name
        liked = dto.liked
        minPrice = dto.minPrice
        maxPrice = dto.maxPrice
        releaseForm = dto.releaseForm
        picture = dto.picture
    }
}

// MARK: - Entity
extension RecentMedicineEntity: Entity {

    public static var primaryKey: String {
        return #keyPath(productId)
    }
}
