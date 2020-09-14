//
//  PharmacyResponse.swift
//  Pharmacy
//
//  Created by CGI-Kite on 14.09.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation

struct PharmacyResponse: Codable {
    
    enum Keys: String, CodingKey {
        case items
        case currentPageNumber
        case numItemsPerPage
    }
    
    let pharmacies: [PharmacyModel]
    let pagesPerPage: Int
    let pageNumber: Int
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        pharmacies = try container.decode([PharmacyModel].self, forKey: .items)
        pagesPerPage = try container.decode(Int.self, forKey: .numItemsPerPage)
        pageNumber = try container.decode(Int.self, forKey: .currentPageNumber)
    }
}
