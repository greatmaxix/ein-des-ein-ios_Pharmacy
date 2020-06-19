//
//  PhonePhormatter.swift
//  Pharmacy
//
//  Created by CGI-Kite on 17.06.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation

//swiftlint:disable identifier_name

class PhoneFormatter {
    
    func formattedNumber(number: String) -> String {
        
        let cleanPhoneNumber: String
        if number.contains("+7") {
            
            cleanPhoneNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        } else {
            cleanPhoneNumber = ("7" + number).components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        }
        
        let mask = "+X (XXX) XXX-XXXX"

        var result = ""
        var index = cleanPhoneNumber.startIndex
        for ch in mask where index < cleanPhoneNumber.endIndex {
            if ch == "X" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
}
