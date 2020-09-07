//
//  PhonePhormatter.swift
//  Pharmacy
//
//  Created by CGI-Kite on 17.06.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation

private struct Const {
    static let kaz: String = "7"
    static let phoneNumberLength = 10
}

protocol PhoneFormatePresentable {
    var countryCode: String { get }
    var phoneNumberLength: Int { get }
    var phoneFormatMask: String { get }
}

class PhoneFormatter {
    
    // MARK: - Properties
    private let phoneFormate: PhoneFormatePresentable
    
    // MARK: - Init / Deinit methods
    init() {
        #if DEBUG
        phoneFormate = UkrainianFormat()
        #else
        phoneFormate = KazakhFormat()
        #endif
    }
    
    // MARK: - Public methods
    func formattedNumber(number: String, needsCountryCode: Bool = true) -> String {
        var cleanPhoneNumber: String = number
        if needsCountryCode, !number.contains("+" + phoneFormate.countryCode) {
            cleanPhoneNumber = (phoneFormate.countryCode + number)
                .components(separatedBy: CharacterSet.decimalDigits.inverted)
                .joined()
        } else {
            cleanPhoneNumber = number
                .components(separatedBy: CharacterSet.decimalDigits.inverted)
                .joined()
        }

        var result = ""
        var index = cleanPhoneNumber.startIndex
        for ch in phoneFormate.phoneFormatMask where index < cleanPhoneNumber.endIndex {
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
        let cleanPhoneNumber: String = number
        let mask = phoneFormate.phoneFormatMask
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

// MARK: - External declaration
private extension PhoneFormatter {
    
    struct UkrainianFormat: PhoneFormatePresentable {
        let countryCode: String = "38"
        let phoneNumberLength: Int = 10
        var phoneFormatMask: String = "+XX (XXX) XXX-XXXX"
    }
    
    struct KazakhFormat: PhoneFormatePresentable {
        let countryCode: String = "7"
        let phoneNumberLength: Int = 10
        var phoneFormatMask: String = "+X (XXX) XXX-XXXX"
    }
}
