//
//  Product.swift
//  Pharmacy
//
//  Created by Anton Bal’ on 13.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import Moya

struct Product: Decodable, Equatable {
    
    static func == (lhs: Product, rhs: Product) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    // MARK: - Properties
    let identifier: Int
    let name: String
    let releaseForm: String
    let description: String
    let category: String
    var imageURLs: [URL]
    let activeSubstances: [String]
    let manufacturer: Manufacturer
    let isLiked: Bool
    
    var currency = "₸"
    var minPrice: String {
        return  priceRange?.minPrice.moneyString(with: currency) ?? "--"
    }
    var maxPrice: String {
        return  priceRange?.minPrice.moneyString(with: currency) ?? "--"
    }
    
    private let priceRange: PriceRange?

    // MARK: - Init / Deinit methods
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        identifier = try container.decode(Int.self, forKey: .globalProductId)
        name = try container.decode(String.self, forKey: .rusName)
        releaseForm = try container.decode(String.self, forKey: .releaseForm)
        description = try container.decode(String.self, forKey: .description)
        category = try container.decode(String.self, forKey: .category)

        var picturesUnkeyedContainer = try? container.nestedUnkeyedContainer(forKey: .pictures)
        let urlContainer = try? picturesUnkeyedContainer?.nestedContainer(keyedBy: Keys.self)
        imageURLs = []
        if let pictureUrl = try? urlContainer?.decode(URL.self, forKey: .url) {
            imageURLs = [pictureUrl]
        }
        
        activeSubstances = try container.decode([String].self, forKey: .activeSubstances)
        manufacturer = try container.decode(Manufacturer.self, forKey: .manufacturerData)
        priceRange = try container.decodeIfPresent(PriceRange.self, forKey: .pharmacyProductsAggregationData)
        isLiked = (try? container.decode(Bool.self, forKey: .liked)) ?? false
    }
}

// MARK: - Coding Keys
extension Product {
    
    enum Keys: String, CodingKey {
        case globalProductId
        case rusName
        case releaseForm
        case description
        case category
        case pictures
        case activeSubstances
        case manufacturerData
        case pharmacyProductsAggregationData
        case liked
        case url
    }
}

extension Product {
    static func mock() -> Product? {
       let string = "{\"globalProductId\":784,\"rusName\":\"\\u0414\\u0435-\\u041d\\u043e\\u043b<SUP>&reg;<\\/SUP>\",\"releaseForm\":\"&loz; \\u0442\\u0430\\u0431., \\u043f\\u043e\\u043a\\u0440. \\u043f\\u043b\\u0435\\u043d\\u043e\\u0447\\u043d\\u043e\\u0439 \\u043e\\u0431\\u043e\\u043b\\u043e\\u0447\\u043a\\u043e\\u0439, 304.6 \\u043c\\u0433: 32, 56 \\u0438\\u043b\\u0438 112 \\u0448\\u0442.\",\"description\":\"&loz; \\u0422\\u0430\\u0431\\u043b\\u0435\\u0442\\u043a\\u0438, \\u043f\\u043e\\u043a\\u0440\\u044b\\u0442\\u044b\\u0435 \\u043f\\u043b\\u0435\\u043d\\u043e\\u0447\\u043d\\u043e\\u0439 \\u043e\\u0431\\u043e\\u043b\\u043e\\u0447\\u043a\\u043e\\u0439 \\u043a\\u0440\\u0435\\u043c\\u043e\\u0432\\u043e-\\u0431\\u0435\\u043b\\u043e\\u0433\\u043e \\u0446\\u0432\\u0435\\u0442\\u0430, \\u043a\\u0440\\u0443\\u0433\\u043b\\u044b\\u0435, \\u0434\\u0432\\u043e\\u044f\\u043a\\u043e\\u0432\\u044b\\u043f\\u0443\\u043a\\u043b\\u044b\\u0435, \\u0441 \\u043d\\u0430\\u0434\\u043f\\u0438\\u0441\\u044c\\u044e \\\"gbr 152\\\", \\u0432\\u044b\\u0434\\u0430\\u0432\\u043b\\u0435\\u043d\\u043d\\u043e\\u0439 \\u043d\\u0430 \\u043e\\u0434\\u043d\\u043e\\u0439 \\u0441\\u0442\\u043e\\u0440\\u043e\\u043d\\u0435, \\u0438 \\u0433\\u0440\\u0430\\u0444\\u0438\\u0447\\u0435\\u0441\\u043a\\u0438\\u043c \\u0440\\u0438\\u0441\\u0443\\u043d\\u043a\\u043e\\u043c \\u0432 \\u0432\\u0438\\u0434\\u0435 \\u043a\\u0432\\u0430\\u0434\\u0440\\u0430\\u0442\\u0430 \\u0441 \\u043f\\u0440\\u0435\\u0440\\u044b\\u0432\\u0438\\u0441\\u0442\\u044b\\u043c\\u0438 \\u0441\\u0442\\u043e\\u0440\\u043e\\u043d\\u0430\\u043c\\u0438 \\u0438 \\u0437\\u0430\\u043a\\u0440\\u0443\\u0433\\u043b\\u0435\\u043d\\u043d\\u044b\\u043c\\u0438 \\u0443\\u0433\\u043b\\u0430\\u043c\\u0438, \\u0432\\u044b\\u0434\\u0430\\u0432\\u043b\\u0435\\u043d\\u043d\\u044b\\u043c \\u043d\\u0430 \\u0434\\u0440\\u0443\\u0433\\u043e\\u0439 \\u0441\\u0442\\u043e\\u0440\\u043e\\u043d\\u0435, \\u0431\\u0435\\u0437 \\u0437\\u0430\\u043f\\u0430\\u0445\\u0430 \\u0438\\u043b\\u0438 \\u0441 \\u043b\\u0435\\u0433\\u043a\\u0438\\u043c \\u0437\\u0430\\u043f\\u0430\\u0445\\u043e\\u043c \\u0430\\u043c\\u043c\\u0438\\u0430\\u043a\\u0430.\\n\\n\\n\\n1 \\u0442\\u0430\\u0431.\\n\\n\\u0432\\u0438\\u0441\\u043c\\u0443\\u0442\\u0430 \\u0442\\u0440\\u0438\\u043a\\u0430\\u043b\\u0438\\u044f \\u0434\\u0438\\u0446\\u0438\\u0442\\u0440\\u0430\\u0442\\n304.6 \\u043c\\u0433,\\n\\n&emsp;\\u0447\\u0442\\u043e \\u0441\\u043e\\u043e\\u0442\\u0432\\u0435\\u0442\\u0441\\u0442\\u0432\\u0443\\u0435\\u0442 \\u0441\\u043e\\u0434\\u0435\\u0440\\u0436\\u0430\\u043d\\u0438\\u044e \\u0432\\u0438\\u0441\\u043c\\u0443\\u0442\\u0430 \\u043e\\u043a\\u0441\\u0438\\u0434\\u0430\\n120 \\u043c\\u0433\\n[PRING] \\u043a\\u0440\\u0430\\u0445\\u043c\\u0430\\u043b \\u043a\\u0443\\u043a\\u0443\\u0440\\u0443\\u0437\\u043d\\u044b\\u0439 - 70.6 \\u043c\\u0433, \\u043f\\u043e\\u0432\\u0438\\u0434\\u043e\\u043d \\u041a30 - 17.7 \\u043c\\u0433, \\u043f\\u043e\\u043b\\u0438\\u0430\\u043a\\u0440\\u0438\\u043b\\u0430\\u0442 \\u043a\\u0430\\u043b\\u0438\\u044f - 23.6 \\u043c\\u0433, \\u043c\\u0430\\u043a\\u0440\\u043e\\u0433\\u043e\\u043b 6000 - 6 \\u043c\\u0433, \\u043c\\u0430\\u0433\\u043d\\u0438\\u044f \\u0441\\u0442\\u0435\\u0430\\u0440\\u0430\\u0442 - 2 \\u043c\\u0433.\\n\\u0421\\u043e\\u0441\\u0442\\u0430\\u0432 \\u043e\\u0431\\u043e\\u043b\\u043e\\u0447\\u043a\\u0438: \\u043e\\u043f\\u0430\\u0434\\u0440\\u0430\\u0439 OY-S-7366 (\\u0433\\u0438\\u043f\\u0440\\u043e\\u043c\\u0435\\u043b\\u043b\\u043e\\u0437\\u0430 5 \\u043c\\u041f\\u0430&middot;\\u0441 - 3.2 \\u043c\\u0433, \\u043c\\u0430\\u043a\\u0440\\u043e\\u0433\\u043e\\u043b 6000 - 1.1 \\u043c\\u0433).\\n8 \\u0448\\u0442. - \\u0431\\u043b\\u0438\\u0441\\u0442\\u0435\\u0440\\u044b (4) - \\u043f\\u0430\\u0447\\u043a\\u0438 \\u043a\\u0430\\u0440\\u0442\\u043e\\u043d\\u043d\\u044b\\u0435.8 \\u0448\\u0442. - \\u0431\\u043b\\u0438\\u0441\\u0442\\u0435\\u0440\\u044b (7) - \\u043f\\u0430\\u0447\\u043a\\u0438 \\u043a\\u0430\\u0440\\u0442\\u043e\\u043d\\u043d\\u044b\\u0435.8 \\u0448\\u0442. - \\u0431\\u043b\\u0438\\u0441\\u0442\\u0435\\u0440\\u044b (14) - \\u043f\\u0430\\u0447\\u043a\\u0438 \\u043a\\u0430\\u0440\\u0442\\u043e\\u043d\\u043d\\u044b\\u0435.\",\"category\":\"Bismuth subcitrate\",\"categoryAtcCode\":\"A02BX05\",\"pictures\":[{\"url\":\"https:\\/\\/api.pharmacies.fmc-dev.com\\/uploads\\/images\\/media\\/cache\\/product_picture_medium\\/7c238529-3335-4ab2-a207-cbfe01301bb2.jpg\"}],\"activeSubstances\":[\"\\u0432\\u0438\\u0441\\u043c\\u0443\\u0442\\u0430 \\u0442\\u0440\\u0438\\u043a\\u0430\\u043b\\u0438\\u044f \\u0434\\u0438\\u0446\\u0438\\u0442\\u0440\\u0430\\u0442\"],\"manufacturerData\":{\"localName\":\"ASTELLAS PHARMA EUROPE\",\"iso3CountryCode\":\"NLD\"},\"pharmacyProductsAggregationData\":{\"minPrice\":685.5,\"maxPrice\":685.5},\"liked\":false}}"
        let d = JSONDecoder()
        
        do {
            return try d.decode(Product.self, from: string.data(using: .utf8)!)
        } catch {
            return nil
        }
    }
}
