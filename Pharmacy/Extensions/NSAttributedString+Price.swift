//
//  NSAttributedString+Price.swift
//  Pharmacy
//
//  Created by Anton Bal’ on 12.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation

extension NSAttributedString {
    
    static func fromPriceAttributed(for price: String, currency: String? = nil) -> NSAttributedString {
        priceAttributed(for: price,
                        prefixText: R.string.localize.generalPriceFrom(),
                        currency: currency)
    }
    
    static func toPriceAttributed(for price: String, currency: String? = nil) -> NSAttributedString {
        priceAttributed(for: price,
                        prefixText: R.string.localize.generalPriceTo(),
                        currency: currency)
    }
    
    private static func priceAttributed(for price: String, prefixText: String, currency: String?) -> NSAttributedString {
        var text = "\(prefixText) \(price)"
        if let currency = currency {
            text += "  \(currency)"
        }
        
        let fromFont = R.font.openSansRegular(size: 12)!
        let font =  R.font.openSansBold(size: 18)!
        let color = R.color.welcomeBlue()!
        
        let att = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.font: font, .foregroundColor: color])
        att.addAttribute(.font, value: fromFont, range: NSRange(location: 0, length: prefixText.count))
        
        return att
    }
}
