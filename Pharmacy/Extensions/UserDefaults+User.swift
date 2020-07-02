//
//  NSUserDefaults+User.swift
//  Pharmacy
//
//  Created by CGI-Kite on 02.07.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    func saveUser(user: User) {
        if let data = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(data, forKey: "user")
        }
    }
    
    func getCurrentUser() -> User? {
        
        let decoder = JSONDecoder()

        if let data: Data = UserDefaults.standard.data(forKey: "user") {
            
            do {
                let user = try decoder.decode(User.self, from: data)
                return user
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
