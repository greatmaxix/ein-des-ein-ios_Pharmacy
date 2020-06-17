//
//  BaseTextValidator.swift
//  testProjs7472
//
//  Created by CGI-Kite on 16.06.2020.
//  Copyright © 2020 none. All rights reserved.
//

import Foundation

class BaseTextValidator {
    
    enum ValidatorType {
        case name
        case phone
        case email
    }
    
    var type: ValidatorType {
        fatalError("BaseTextValidator not implemented")
    }
    
    var pattern: String {
        fatalError("BaseTextValidator not implemented")
    }
    
    var errorText: String {
        fatalError("BaseTextValidator not implemented")
    }
        
    func validate(text: String?) -> Bool {
        
        if let regularExpression: NSRegularExpression = try? NSRegularExpression(pattern: pattern, options: .dotMatchesLineSeparators), let text: String = text {

            let result: NSTextCheckingResult? = regularExpression.firstMatch(in: text, options: .anchored, range: NSRange(location: 0, length: text.count))
            return result != nil
        }
        return false
    }
}
