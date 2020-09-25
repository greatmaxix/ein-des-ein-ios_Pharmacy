//
//  Decimal+MoneyFormat.swift
//  Pharmacy
//
//  Created by Sapa Denys on 18.09.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation

extension Decimal {
    
    func moneyString(with currencySymbol: String? = nil) -> String? {
        return NumberFormatter
            .moneyFormatWithSeparator(and: currencySymbol)
            .string(for: self)
    }
}

extension NumberFormatter {

    static func moneyFormatWithSeparator(and currencySymbol: String? = nil) -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        if let currencySymbol = currencySymbol {
            formatter.currencySymbol = currencySymbol
        }
        formatter.locale = Locale.current
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.roundingMode = .up
        return formatter
    }
}
