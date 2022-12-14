//
//  Category.swift
//  Pharmacy
//
//  Created by Anton Bal’ on 12.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation

//struct CategoriesResponse: Decodable {
//
//    enum Keys: String, CodingKey {
//        case items
//    }
//
//    let categories: [Category]
//
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: Keys.self)
//        categories = try container.decode([Category].self, forKey: .items)
//    }
//}

typealias CategoriesResponse = [Category]

final class Category: Decodable {
    
    let id: Int
    let level: Int
    let title: String
    let url: String?
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
        return level == 0
    }
    
    var imageURL: URL? {
        guard let url = url else {
            return nil
        }
        return URL(string: url)
    }

    enum Keys: String, CodingKey {
        case name
        case nodes
        case lvl
        case id
        case url
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        title = try container.decode(String.self, forKey: .name)
        level = try container.decode(Int.self, forKey: .lvl)
        id = try container.decode(Int.self, forKey: .id)
        subCategories = try? container.decode([Category]?.self, forKey: .nodes)
        url = try? container.decode(String?.self, forKey: .url)
    }
    
    init(title: String, imageURL: URL?, level: Int, id: Int) {
        self.title = title
        self.level = level
        self.id = id
        self.url = nil
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
