//
//  Receipt.swift
//  Pharmacy
//
//  Created by Anton Bal’ on 12.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation

struct Receipt {
    let title: String
    let subtitle: String
    let imageURL: URL?
    let price: String
    var currency = "₽"
}
