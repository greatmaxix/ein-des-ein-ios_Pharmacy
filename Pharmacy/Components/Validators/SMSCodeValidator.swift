//
//  SMSCodeValidator.swift
//  Pharmacy
//
//  Created by CGI-Kite on 19.06.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation

class SMSCodeValidator: BaseTextValidator {

    override var type: BaseTextValidator.ValidatorType {
        return .smsCode
    }

    override var pattern: String {
        return "^[0-9]{6}$"
    }
}
