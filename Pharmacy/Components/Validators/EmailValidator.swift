//
//  EmailValidator.swift
//  testProjs7472
//
//  Created by CGI-Kite on 16.06.2020.
//  Copyright © 2020 none. All rights reserved.
//

import Foundation

class EmailValidator: BaseTextValidator {
    
    override var type: BaseTextValidator.ValidatorType {
        return .email
    }
    
    override var pattern: String {
        return "^[a-zA-Z0-9._-]{3,32}\\@[a-zA-Z0-9_-]{3,18}\\.[a-z]{2,5}$"
    }
    
    override var errorText: String {
        return R.string.localize.errorEmail.localized()
    }
}
