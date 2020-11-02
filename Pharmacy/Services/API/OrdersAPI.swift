//
//  OrdersAPI.swift
//  Pharmacy
//
//  Created by Mikhail Timoscenko on 01.11.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import Moya

enum OrdersAPI {
    case createOrderWith(
            order: PharmCartOrder,
            contact: OrderContactInfo,
            address: OrderDeliveryAddress?,
            paymentType: String,
            deliveryType: String
         )
}

extension OrdersAPI: RequestConvertible {

    var path: String {
        switch self {
        case .createOrderWith:
            return "customer/order"
        }
    }

    var method: Moya.Method {
        switch self {
        case .createOrderWith:
            return .post
        }
    }

    var task: Task {
        switch self {
        case .createOrderWith(let order, let contact, let address, let paymentType, let deliveryType):
            var items: [[String: Any]] = []

            for product in order.products {
                let object = [
                    "pharmacyProductId": product.pharmacyProductId,
                    "requestedPrice": product.price ?? 0,
                    "count": product.productCount
                ] as [String: Any]
                items.append(object)
            }

            var parameters: [String: Any] = [:]

            parameters["pharmacyProductOrderCreateDataList"] = items

            parameters["paymentType"] = paymentType
            parameters["deliveryPrice"] = 0
            parameters["pharmacyId"] = order.id

            let contactInfo = [
                "name": contact.name,
                "phone": contact.phone,
                "email": contact.email
            ]

            parameters["contactInfo"] = contactInfo

            let deliveryInfo = [
                "type": deliveryType,
                "comment": "Пустой комментарий",
                "address": [
                    "city": address?.city,
                    "street": address?.street,
                    "house": address?.house,
                    "apartment": address?.appartment
                ] as [String: String?]
            ] as [String: Any]

            parameters["deliveryInfo"] = deliveryInfo

            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }

}
