//
//  NameValidator.swift
//  Pharmacy
//
//  Created by CGI-Kite on 17.06.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation

class NameValidator: BaseTextValidator {
    
    override var type: BaseTextValidator.ValidatorType {
        return .name
    }
    
    override var pattern: String {
        return "^(\\s)*[A-Za-z]+((\\s)?((\\'|\\-|\\.)?([A-Za-z])+))*(\\s)*{2,60}$"
    }
    
    override var errorText: String {
        return R.string.localize.errorName()
    }
}
