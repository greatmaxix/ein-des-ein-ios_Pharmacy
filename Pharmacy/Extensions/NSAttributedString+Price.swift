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
        priceAttributed(for: price, currency: currency, prefixText: R.string.localize.generalPriceFrom())
    }
    
    static func toPriceAttributed(for price: String, currency: String ) -> NSAttributedString {
        priceAttributed(for: price, currency: currency, prefixText: R.string.localize.generalPriceTo())
    }
    
    static func priceAttributed(for price: String, currency: String, prefixText: String) -> NSAttributedString {
        let text = "\(prefixText) \(price) \(currency)"
        
        let fromFont = R.font.openSansRegular(size: 12)!
        let font =  R.font.openSansSemiBold(size: 24)!
        let color = R.color.welcomeBlue()!
        
        let att = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.font: font, .foregroundColor: color])
        att.addAttribute(.font, value: fromFont, range: NSRange(location: 0, length: prefixText.count))
        
        return att
    }
}
