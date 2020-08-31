//
//  PhonePhormatter.swift
//  Pharmacy
//
//  Created by CGI-Kite on 17.06.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation

//swiftlint:disable identifier_name

private struct Const {
    static let kaz: String = "7"
    static let phoneNumberLength = 10
}

class PhoneFormatter {
    
    func formattedNumber(number: String, needsCountryCode: Bool = true) -> String {
        
        var cleanPhoneNumber: String = number
        if needsCountryCode, !number.contains("+" + Const.kaz) {

            cleanPhoneNumber = (Const.kaz + number).components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        } else {
            cleanPhoneNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
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
    
    func formattedFinalNumber(number: String) -> String {
        
        var cleanPhoneNumber: String = number

        let partOfMask = " (XXX) XXX-XXXX"
        let countryCodeLength: Int = number.count - Const.phoneNumberLength
        let mask = "+" + String(repeating: "X", count: max(countryCodeLength, 0)) + partOfMask
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
