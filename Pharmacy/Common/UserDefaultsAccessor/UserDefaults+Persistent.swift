//
//  UserDefaults+Persistent.swift
//  Pharmacy
//
//  Created by Sapa Denys on 03.09.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    // MARK: - Internal properties
    /**
     Data saved into `persistentUserDefaults` will not delete on logout
     */
    static var persistent: UserDefaults = {
        guard let persistent = UserDefaults(suiteName: persistentDomain) else {
            fatalError("Can not create Persistent UserDefaults domain")
        }
        return persistent
    }()
    
    // MARK: - Private properties
    static private let persistentDomain = {
        Bundle.main.bundleIdentifier!  + ".persistent"
    }()
}
