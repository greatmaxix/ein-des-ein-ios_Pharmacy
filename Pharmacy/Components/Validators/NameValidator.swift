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
        return "^[^_ !¡?÷?¿\u{fe68}/\u{fe68}\u{fe68}+=@#$%ˆ&*(){}|~<>;:[\u{fe68}]]{2,12}$"
    }
    
    override var errorText: String {
        return R.string.localize.errorName()
    }
}
