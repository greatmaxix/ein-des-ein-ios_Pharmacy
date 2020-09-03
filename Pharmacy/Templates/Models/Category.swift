//
//  Category.swift
//  Pharmacy
//
//  Created by Anton Bal’ on 12.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation

struct CategoriesResponse: Decodable {
    
    enum Keys: String, CodingKey {
        case items
    }
    
    let categories: [Category]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        categories = try container.decode([Category].self, forKey: .items)
    }
}

final class Category: Decodable {
    
    let title: String
    let imageURL: URL? = nil
    private let code: String
    let subCategories: [Category]?
    
    enum Keys: String, CodingKey {
        case rusName
        case nodes
        case code
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        title = try container.decode(String.self, forKey: .rusName)
        code = try container.decode(String.self, forKey: .code)
        subCategories = try? container.decode([Category].self, forKey: .nodes)
    }
    
    init(title: String, imageURL: URL?) {
        self.title = title
        code = "A"
        subCategories = nil
    }
}
