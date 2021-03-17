//
//  Locale+Extension.swift
//  Pharmacy
//
//  Created by Anna Yatsun on 17.03.2021.
//  Copyright © 2021 pharmacy. All rights reserved.
//

import Foundation

extension Locale {

    public static var appLocale: Locale {
        get {
            return Locale(identifier: LanguageService.current.getCurrentLanguageModel().languageCode)
        }
    }
}
