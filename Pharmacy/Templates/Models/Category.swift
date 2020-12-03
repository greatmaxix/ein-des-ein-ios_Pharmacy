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
    let code: String
    let subCategories: [Category]?
    
    var imageTitle: String {
        let text = title.components(separatedBy: " ").first
        let result = text ?? ""
        return result
    }
    
    var shortTitle: String {
        let maxLength = 20
        if title.count - maxLength > 0 {
            return String(title.dropLast(title.count - maxLength)) + "..."
        }
        return title
    }
    
    var isRootCategory: Bool {
        return code == "A"
    }

    enum Keys: String, CodingKey {
        case name
        case nodes
        case code
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        title = try container.decode(String.self, forKey: .name)
        code = try container.decode(String.self, forKey: .code)
        subCategories = try? container.decode([Category].self, forKey: .nodes)
    }
    
    init(title: String, imageURL: URL?, code: String? = nil) {
        self.title = title
        self.code = code ?? "A"
        subCategories = nil
    }
    
    func allCategories() -> [Category] {
        var a: [Category] = []
        a.append(self)
        for c in subCategories ?? [] {
            a.append(c)
            if let subcategories = c.subCategories, subcategories.count > 0 {
                a.append(contentsOf: c.allCategories())
            }
        }
        return a
    }
}
