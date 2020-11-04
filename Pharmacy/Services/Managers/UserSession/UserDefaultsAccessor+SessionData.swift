//
//  UserDefaultsAccessor+SessionData.swift
//  Pharmacy
//
//  Created by Sapa Denys on 03.09.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation

extension UserDefaultsAccessor: UserSessionDataAccessible {
    
    static var userId: Int {
        get {
            UserDefaultsAccessor.value(for: \.userIdentifier)
        }
        set {
            UserDefaultsAccessor.write(value: newValue, for: \.userIdentifier)
        }
    }
    
    static var regionId: Int {
        get {
            UserDefaultsAccessor.value(for: \.regionId)
        }
        set {
            UserDefaultsAccessor.write(value: newValue, for: \.regionId)
        }
    }
    
    static var regionName: String {
        get {
            UserDefaultsAccessor.value(for: \.regionName)
        }
        set {
            UserDefaultsAccessor.write(value: newValue, for: \.regionName)
        }
    }
    
    static func removeUserId() {
        UserDefaultsAccessor.removeValue(for: \.userIdentifier)
    }
}
