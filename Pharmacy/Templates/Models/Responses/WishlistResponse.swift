//
//  WishlistResponse.swift
//  Pharmacy
//
//  Created by CGI-Kite on 08.09.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation

struct WishlistResponse: Codable {

    let medicines: [Medicine]
    let currentPage: Int
    let totalNumberOfItems: Int

    enum Keys: String, CodingKey {
        case items
        case currentPageNumber
        case totalCount
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)

        medicines = try container.decode([Medicine].self, forKey: .items)
        currentPage = try container.decode(Int.self, forKey: .currentPageNumber)
        totalNumberOfItems = try container.decode(Int.self, forKey: .totalCount)
    }
}

struct ListContainerResponse<Entity: Decodable>: Decodable {

    let entities: [Entity]
    let currentPage: Int
    let totalNumberOfItems: Int

    enum Keys: String, CodingKey {
        case items
        case currentPageNumber
        case totalCount
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)

        entities = try container.decode([Entity].self, forKey: .items)
        currentPage = try container.decode(Int.self, forKey: .currentPageNumber)
        totalNumberOfItems = try container.decode(Int.self, forKey: .totalCount)
    }
}

struct SingleItemContainerResponse<Entity: Decodable>: Decodable {

    let item: Entity
}
