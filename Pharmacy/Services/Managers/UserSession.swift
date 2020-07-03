//
//  UserSession.swift
//  Pharmacy
//
//  Created by CGI-Kite on 03.07.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation

class UserSession {
    
    static let shared: UserSession = UserSession()
    
    func save(user: User, token: String) {
        
        UserDefaults.standard.saveUser(user: user)
        KeychainManager.shared.saveToken(token: token)
    }
}
