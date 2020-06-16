//
//  SampleResponseModel.swift
//  Pharmacy
//
//  Created by Mikhail Timoscenko on 16.06.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation

struct SampleResponseModel: Equatable, Codable {

    var name: String
    var phone: String

    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case phone = "Phone"
    }

}
