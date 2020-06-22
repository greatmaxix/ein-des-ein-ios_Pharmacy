//
//  PhoneValidator.swift
//  testProjs7472
//
//  Created by CGI-Kite on 16.06.2020.
//  Copyright © 2020 none. All rights reserved.
//

import Foundation

class PhoneValidator: BaseTextValidator {
    
    override var type: BaseTextValidator.ValidatorType {
        return .phone
    }
    
    override var pattern: String {
        return "^\\+[0-9]{1,3}\\s\\({0,1}[0-9]{3}\\)\\s{0,1}[0-9]{3}[ -]{0,1}[0-9]{4}$"
    }
    
    override var errorText: String {
        return R.string.localize.errorPhone()
    }
}
