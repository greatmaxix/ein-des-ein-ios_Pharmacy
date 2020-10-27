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

struct AddToWishListResponse: Codable {
    let message: String?
    let status: String?
    let data: [Int]?
    
    enum Keys: String, CodingKey {
        case message
        case status
        case data
    }
    
    init(from decoder: Decoder) throws {
        let container = try? decoder.container(keyedBy: Keys.self)
        
        message = try container?.decode(String.self, forKey: .message)
        status = try container?.decode(String.self, forKey: .status)
        data = try? container?.decode([Int].self, forKey: .data)
    }
}