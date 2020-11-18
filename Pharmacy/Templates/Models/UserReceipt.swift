//
//  UserReceipt.swift
//  Pharmacy
//
//  Created by Mikhail Timoscenko on 13.11.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation

struct UserReceiptsResponse: Codable {

    var items: [UserReceipt]

    enum Keys: String, CodingKey {
        case items
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)

        items = try container.decode([UserReceipt].self, forKey: .items)
    }
}

//
//0 : 6 elements
// ▿ 0 : 2 elements
//   - key : status
//   - value : closed
// ▿ 1 : 2 elements
//   - key : id
//   - value : 1
// ▿ 2 : 2 elements
//   - key : code
//   - value : KUZW6TRV45
// ▿ 3 : 2 elements
//   - key : validTill
//   - value : 2020-12-13T09:21:48+02:00
// ▿ 4 : 2 elements
//   - key : recipeProducts
//   ▿ value : 1 element
//     ▿ 0 : 2 elements
//       ▿ 0 : 2 elements
//         - key : count
//         - value : 3
//       ▿ 1 : 2 elements
//         - key : globalProduct
//         ▿ value : 4 elements
//           ▿ 0 : 2 elements
//             - key : globalProductId
//             - value : 744
//           ▿ 1 : 2 elements
//             - key : releaseForm
//             - value : &loz; мазь д/наружн. прим. 0.1%: тубы 5 г, 15 г, 20 г, 25 г, 30 г или 50 г
//           ▿ 2 : 2 elements
//             - key : rusName
//             - value : АДВАНТАН<SUP>&reg;</SUP>
//           ▿ 3 : 2 elements
//             - key : pictures
//             ▿ value : 1 element
//               - 0 : 0 elements
// ▿ 5 : 2 elements
//   - key : doctor
//   ▿ value : 2 elements
//     ▿ 0 : 2 elements
//       - key : name
//       - value : doctor1 doctor1
//     ▿ 1 : 2 elements
//       - key : avatar
//       - value : <null>
//         - super : NSObject

struct UserReceipt: Codable {

    var id: Int
    var text: String?
    var code: String?
    var productURL: String?
    var amount: Int?
    var doctorURL: String?
    var doctorName: String?
    var status: String?
    var validTill: String?
    var pdfLink: String?

    enum Keys: String, CodingKey {
        case id
        case status
        case code
        case validTill
        case recipeProducts
        case count
        case globalProduct
        case rusName
        case doctor
        case pictures
        case avatar
        case name
        case image
        case uuid
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)

        id = try container.decode(Int.self, forKey: .id)
        status = try? container.decode(String.self, forKey: .status)
        code = try? container.decode(String.self, forKey: .code)
        validTill = try? container.decode(String.self, forKey: .validTill)

        var productsContainer = try? container.nestedUnkeyedContainer(forKey: .recipeProducts)
        let test = try? productsContainer?.nestedContainer(keyedBy: Keys.self)
        amount = try? test?.decode(Int.self, forKey: .count)

        let productContainer = try? test?.nestedContainer(keyedBy: Keys.self, forKey: .globalProduct)
        text = try? productContainer?.decode(String.self, forKey: .rusName)

        let doctorContainer = try? container.nestedContainer(keyedBy: Keys.self, forKey: .doctor)
        doctorName = try? doctorContainer?.decode(String.self, forKey: .name)

        var pictureContainer = try? container.nestedContainer(keyedBy: Keys.self, forKey: .image)
        pdfLink = try? pictureContainer?.decode(String.self, forKey: .uuid)
    }

}
