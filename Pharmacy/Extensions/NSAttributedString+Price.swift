//
//  NSAttributedString+Price.swift
//  Pharmacy
//
//  Created by Anton Bal’ on 12.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation


extension NSAttributedString {
    
    static func fromPriceAttributed(for price: String, currency: String ) -> NSAttributedString {
        let fromText = R.string.localize.generalPriceFrom()
        let text = "\(fromText) \(price) \(currency)"
        
        let fromFont = R.font.openSansRegular(size: 12)!
        let font =  R.font.openSansSemiBold(size: 24)!
        let color = R.color.welcomeBlue()!
        
        let att = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.font: font, .foregroundColor: color])
        att.addAttribute(.font, value: fromFont, range: NSRange(location: 0, length: fromText.count))
        
        return att
    }
}
