//
//  UserDefaultsAccessor+SessionData.swift
//  Pharmacy
//
//  Created by Sapa Denys on 03.09.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation

extension UserDefaultsAccessor: UserSessionDataAccessible {
    
    static var userId: UInt64 {
        get {
            UserDefaultsAccessor.value(for: \.userIdentifier)
        }
        set {
            UserDefaultsAccessor.write(value: newValue, for: \.userIdentifier)
        }
    }
    
    static func removeUserId() {
        UserDefaultsAccessor.removeValue(for: \.userIdentifier)
    }
}
