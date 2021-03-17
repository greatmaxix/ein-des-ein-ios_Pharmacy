//
//  ExtensionString .swift
//  Snail
//
//  Created by Anna Yatsun on 25/12/2019.
//  Copyright © 2019 snailbuzz. All rights reserved.
//

import Foundation

private let notFoundKey = "___not___found___key"

extension String {

    var pharmacyLocalized: String {
        var value = ""

        if let path = Bundle.main.path(forResource: Locale.appLocale.languageCode, ofType: "lproj"),
            let locBundle = Bundle(path: path) {
            value = locBundle.localizedString(forKey: self, value: notFoundKey, table: nil)
        } else {
            value = Bundle.main.localizedString(forKey: self, value: notFoundKey, table: nil)
        }

        return value == notFoundKey ? self : value
    }
}
