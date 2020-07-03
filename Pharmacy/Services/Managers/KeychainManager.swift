//
//  KeychainManager.swift
//  Pharmacy
//
//  Created by Mikhail Timoscenko on 16.06.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation

class KeychainManager {

    static let shared = KeychainManager()
    private let tokenKey: String = "token" + " " + (Bundle.main.bundleIdentifier ?? "")
    
    var baseURL: URL {
        // Here we can set different URL's for different Envs
        return URL(string: "google.com")!
    }

    var bearerToken: String {
        return tokens?.bearer ?? String()
    }
    
    var tokens: Tokens?
    
    func saveToken(token: String) {
        
        guard let data: Data = token.data(using: .utf8) else { return }
        let query: CFDictionary = [kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: tokenKey,
            kSecValueData as String: data] as CFDictionary

        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }
    
    func getToken() -> String? {

        let getquery: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
        kSecAttrAccount as String: tokenKey,
        kSecReturnData as String: kCFBooleanTrue!,
        kSecMatchLimit as String: kSecMatchLimitOne]

        var dataTypeRef: AnyObject?
        
        let status: OSStatus = SecItemCopyMatching(getquery as CFDictionary, &dataTypeRef)
        
        if status == noErr, let data = dataTypeRef as? Data {
            return String(data: data, encoding: .utf8)
        }
        
        return nil
    }
}
