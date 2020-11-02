//
//  HouseValidator.swift
//  Pharmacy
//
//  Created by Sergey berdnik on 02.11.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation

class HouseValidator: BaseTextValidator {
    
    override var type: BaseTextValidator.ValidatorType {
        return .home
    }
    
    override var pattern: String {
        return "^[1-9][0-9][0-9]?$|^1000$"
    }
    
    override var errorText: String {
        return R.string.localize.deliveryHouseValidation()
    }
}
