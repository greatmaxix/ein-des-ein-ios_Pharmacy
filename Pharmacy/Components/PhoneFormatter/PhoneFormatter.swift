//
//  PhonePhormatter.swift
//  Pharmacy
//
//  Created by CGI-Kite on 17.06.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation

//swiftlint:disable function_body_length

class PhoneFormatter {
    
    private var previousText: String?
    private let separators: String = " ,()"

    private struct Const {
        static let code: Int = 3
        static let endCode: Int = 4
        static let countryCode: String = "+7"
    }
    
    // +7 (XXX) XXX XXXX
    
    func updatePhone(text: String?) -> String? {
    
        guard var startText: String = text, startText.count > 0 else {
            return text
        }
        
        if let previousText: String = previousText, previousText.count > startText.count {
            self.previousText = text
            return text
        }
        
        var result: String = ""
        
        if startText.count < Const.countryCode.count {
            
            //startText.removeAll()
            self.previousText = text
            result = Const.countryCode
            return result + " (" + startText
        } else {
            
            if startText.contains(Const.countryCode) {
                startText.removeFirst(Const.countryCode.count)
            }
            startText.removeAll(where: {separators.contains($0)})
            result = Const.countryCode
        }
        
        if startText.count > Const.code - 1 {
            
            let index = startText.index(startText.startIndex, offsetBy: Const.code)
            let closeScobe: String = String(startText[startText.startIndex..<index])
            result += " (" + closeScobe + ")"
            startText.removeFirst(3)
        } else {
            
            self.previousText = result + " (" + startText
            return result + " (" + startText
        }
        
        if startText.count > Const.code - 1 {
            
            let index = startText.index(startText.startIndex, offsetBy: Const.code)
            let closeScobe: String = String(startText[startText.startIndex..<index])
            result += " " + closeScobe + " "
            startText.removeFirst(3)
        } else {
            
            result += " " + startText
            self.previousText = result
            return result
        }
        
        if startText.count > Const.endCode {
            
            let index = startText.index(startText.startIndex, offsetBy: Const.endCode)
            let closeScobe: String = String(startText[startText.startIndex..<index])
            result += closeScobe
            previousText = result
            return result
        }
        result += startText
        self.previousText = result

        return result
    }
}
