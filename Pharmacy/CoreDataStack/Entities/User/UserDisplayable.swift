//
//  UserDisplayable.swift
//  Pharmacy
//
//  Created by Sapa Denys on 03.09.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation

struct UserDisplayable {
    let name: String
    let uuid: String
    let email: String?
    let phone: String
    var avatarURL: URL?
    var regionName: String?
    var deliveryAddress: String?
    var regionId: Int64?
    var topicName: String?
}
