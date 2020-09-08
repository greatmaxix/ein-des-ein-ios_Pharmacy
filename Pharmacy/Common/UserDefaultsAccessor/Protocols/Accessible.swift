//
//  Accessible.swift
//  Pharmacy
//
//  Created by Sapa Denys on 03.09.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation

protocol Accessible {
    
    // MARK: - Associated Type
    associatedtype Value
    
    // MARK: - Static methods
    static func readValue(for key: String, from storage: UserDefaults) -> Value
    static func write(value: Value, for key: String, into storage: UserDefaults)
    static func removeValue(for key: String, from storage: UserDefaults)
}

// MARK: - Accessible default implementation
extension Accessible {
    
    static func removeValue(for key: String, from storage: UserDefaults) {
        storage.removeObject(forKey: key)
    }
}

// MARK: - String + Accessible
extension String: Accessible {
    
    static func readValue(for key: String, from storage: UserDefaults) -> String {
        guard let value = storage.string(forKey: key) else {
            fatalError("Can not find value of type `String` by key: \(key) in store \(storage)")
        }
        
        return value
    }
    
    static func write(value: String, for key: String, into storage: UserDefaults) {
        storage.set(value, forKey: key)
    }
}

// MARK: - Int + Accessible
extension Int: Accessible {
    
    static func readValue(for key: String, from storage: UserDefaults) -> Int {
        storage.integer(forKey: key)
    }
    
    static func write(value: Int, for key: String, into storage: UserDefaults) {
        storage.set(value, forKey: key)
    }
}

// MARK: - Float + Accessible
extension Float: Accessible {
    
    static func readValue(for key: String, from storage: UserDefaults) -> Float {
        storage.float(forKey: key)
    }
    
    static func write(value: Float, for key: String, into storage: UserDefaults) {
        storage.set(value, forKey: key)
    }
}

// MARK: Double + Accessible
extension Double: Accessible {
    
    static func readValue(for key: String, from storage: UserDefaults) -> Double {
        storage.double(forKey: key)
    }
    
    static func write(value: Double, for key: String, into storage: UserDefaults) {
        storage.set(value, forKey: key)
    }
}

// MARK: - Bool + Accessible
extension Bool: Accessible {
    
    static func readValue(for key: String, from storage: UserDefaults) -> Bool {
        storage.bool(forKey: key)
    }
    
    static func write(value: Bool, for key: String, into storage: UserDefaults) {
        storage.set(value, forKey: key)
    }
}

// MARK: - URL + Accessible
extension URL: Accessible {
    
    static func readValue(for key: String, from storage: UserDefaults) -> URL {
        guard let value = storage.url(forKey: key) else {
            fatalError("""
                Can not find value of type `URL` by key: \(key) in store \(storage).
                If you want to store/get Optional<URL> please provide key type as URL?.
                """)
        }
        
        return value
    }
    
    static func write(value: URL, for key: String, into storage: UserDefaults) {
        storage.set(value, forKey: key)
    }
}

// MARK: - Optional<Accessible> + Accessible
extension Optional: Accessible where Wrapped: Accessible {
    
    typealias Value = Wrapped.Value?
    
    static func readValue(for key: String, from storage: UserDefaults) -> Value {
        guard let value = storage.value(forKey: key) as? Value else {
            fatalError("Can not find value of type \(Value.self) by key: \(key) in store \(storage)")
        }
        
        return value
    }
    
    static func write(value: Value, for key: String, into storage: UserDefaults) {
        storage.set(value, forKey: key)
    }
}

// MARK: - Array<Accessible> + Accessible
extension Array: Accessible where Element: Accessible {
    
    typealias Value = [Element.Value]
    
    static func readValue(for key: String, from storage: UserDefaults) -> Value {
        guard let value = storage.value(forKey: key) as? Value else {
            fatalError("Can not find array of values of type \(Value.self) by key: \(key) in store \(storage)")
        }
        
        return value
    }
    
    static func write(value: Value, for key: String, into storage: UserDefaults) {
        storage.set(value, forKey: key)
    }
}
