//
//  Street&CityValidator.swift
//  Pharmacy
//
//  Created by Sergey berdnik on 02.11.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation

class CityValidator: BaseTextValidator {
    
    override var type: BaseTextValidator.ValidatorType {
        return .cityAndStreet
    }
    
    override var pattern: String {
        return "^[^_ !¡?÷?¿\u{fe68}/\u{fe68}\u{fe68}+=@#$%ˆ&*(){}|~<>;:[\u{fe68}]]{2,20}$"
    }
    
    override var errorText: String {
        return R.string.localize.deliveryStreenAndCityValidation()
    }
}
