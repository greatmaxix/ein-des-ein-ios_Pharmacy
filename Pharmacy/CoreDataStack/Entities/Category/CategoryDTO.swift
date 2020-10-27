//
//  CategoryDTO.swift
//  Pharmacy
//
//  Created by Sergey berdnik on 26.10.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation

struct CategoryDTO: Equatable, Codable {
    let title: String
    var imageURL: String? = ""
    let code: String
    var subCategory: [CategoryDTO]?
}

extension CategoryDTO: Storable {
    
    var entityType: CategoryEntity.Type {
        CategoryEntity.self
    }
    
    var identifier: NSObject {
        NSObject.init()
    }
    
    func fillEntity(entity: CategoryEntity) {
        entity.updateWith(self)
    }
}
