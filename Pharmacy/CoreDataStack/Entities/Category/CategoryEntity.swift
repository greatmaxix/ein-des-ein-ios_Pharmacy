//
//  CategoryEntity.swift
//  Pharmacy
//
//  Created by Sergey berdnik on 26.10.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import CoreData

@objc(CategoryEntity)
final class CategoryEntity: NSManagedObject {
    // MARK: - Properties
    @NSManaged public private(set) var title: String
    @NSManaged public private(set) var imageURL: String?
    @NSManaged public private(set) var code: String
    @NSManaged public private(set) var subCategory: [CategoryEntity]?
    
    // MARK: - Public methods
    func updateWith(_ dto: CategoryDTO) {
        title = dto.title
        imageURL = dto.imageURL
        code = dto.code
    }
    
    func uppdate(subCategory: [CategoryEntity]) {
        subCategory.forEach {self.subCategory?.append($0)}
    }
}

// MARK: - Entity
extension CategoryEntity: Entity {

    public static var primaryKey: String {
        return #keyPath(code)
    }
}
