//
//  Pharmacy.swift
//  Pharmacy
//
//  Created by CGI-Kite on 14.09.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation

struct PharmacyModel: Codable {
    
    struct Geometry: Codable {
        let lat: Double
        let lng: Double
        let address: String
    }

    struct SimpleMedicine: Codable {
        let pharmacyProductId: Int
        let price: Double
    }
    
    let id: Int
    let name: String
    let phone: String?
    let geometry: Geometry
    var imageURL: URL?
    let medicines: [SimpleMedicine]
    
    enum Keys: String, CodingKey {
        case id
        case phone
        case name
        case location
        case url
        case logo
        case pharmacyProducts
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)

        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        phone = try container.decode(String.self, forKey: .phone)
        geometry = try container.decode(Geometry.self, forKey: .location)
        
        let nestedContainer = try container.nestedContainer(keyedBy: Keys.self, forKey: .logo)
        
        if let stringURL: String = try? nestedContainer.decode(String.self, forKey: .url) {
            imageURL = URL(string: stringURL)
        }
        medicines = try container.decode([SimpleMedicine].self, forKey: .pharmacyProducts)
    }
}
