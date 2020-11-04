//
//  UserDefaultsAccessor.swift
//  Pharmacy
//
//  Created by Sapa Denys on 03.09.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation

final class UserDefaultsAccessor {
    
    // MARK: - Properties
    private static let localStorage: UserDefaults = .standard
    private static let persistentStorage: UserDefaults = .persistent
    
    // MARK: - Local storage access methods
    static func value<Type>(for keyPath: KeyPath<StoredValue, Type>) -> Type.Value where Type: Accessible {
        Type.readValue(for: keyPath.stringValue, from: localStorage)
    }
    
    static func write<Type>(value: Type.Value, for keyPath: KeyPath<StoredValue, Type>) where Type: Accessible {
        Type.write(value: value, for: keyPath.stringValue, into: localStorage)
    }
    
    static func removeValue<Type>(for keyPath: KeyPath<StoredValue, Type>) where Type: Accessible {
        Type.removeValue(for: keyPath.stringValue, from: localStorage)
    }
    
    // MARK: - Persistant storage access methods
    static func value<Type>(for keyPath: KeyPath<PersistantValue, Type>) -> Type.Value where Type: Accessible {
        Type.readValue(for: keyPath.stringValue, from: persistentStorage)
    }
    
    static func write<Type>(value: Type.Value, for keyPath: KeyPath<PersistantValue, Type>) where Type: Accessible {
        Type.write(value: value, for: keyPath.stringValue, into: persistentStorage)
    }
    
    static func removeValue<Type>(for keyPath: KeyPath<PersistantValue, Type>) where Type: Accessible {
        Type.removeValue(for: keyPath.stringValue, from: persistentStorage)
    }
    
    // MARK: - Static methods
    public static func clear() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
    }
}

extension UserDefaultsAccessor {
    
    struct StoredValue {
        
        // MARK: - Properties represents key and value type
        let userIdentifier: Int
        let regionId: Int
        let regionName: String
        
        // MARK: - Init / Deinit methods
        private init() {
            fatalError("You can not create `StoredValue` object")
        }
    }
    
    struct PersistantValue {
        
        // MARK: - Properties represents key and value type
        let isPassedOnboarding: Bool
        
        // MARK: - Init / Deinit methods
        private init() {
            fatalError("You can not create `PersistantValue` object")
        }
    }
}

extension PartialKeyPath where Root == UserDefaultsAccessor.StoredValue {
    
    var stringValue: String {
        switch self {
        case \UserDefaultsAccessor.StoredValue.userIdentifier:
            return "userIdentifier"
        case \UserDefaultsAccessor.StoredValue.regionId:
            return "regionId"
        case \UserDefaultsAccessor.StoredValue.regionName:
            return "regionName"
        default:
            fatalError("Unexpected key path")
        }
    }
}

extension PartialKeyPath where Root == UserDefaultsAccessor.PersistantValue {
    
    var stringValue: String {
        switch self {
        case \UserDefaultsAccessor.PersistantValue.isPassedOnboarding:
            return "isNeedToShowBanner"
        default:
            fatalError("Unexpected key path")
        }
    }
}
