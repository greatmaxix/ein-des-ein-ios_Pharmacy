//
//  UserSession.swift
//  Pharmacy
//
//  Created by CGI-Kite on 03.07.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation

typealias EmptyClosure = () -> Void

class UserSession {
    
    // MARK: - Static properties
    static let shared: UserSession = .init()
    
    // MARK: - Properties
    var authorizationStatus: AuthorizationStatus {
        didSet {
            switch authorizationStatus {
            case .notAuthorized:
                userDefaultsAccessor.removeUserId()
            case .authorized(let userId):
                userDefaultsAccessor.userId = userId
                
            }
        }
    }
    var userIdentifier: Int {
        switch authorizationStatus {
        case .authorized(let userId):
            return userId
        case .notAuthorized:
            fatalError("Set `authorizationStatus` as \(String(describing: AuthorizationStatus.authorized)) before")
        }
    }
    
    // TODO: Fix ! when UserSessionDataAccessible will be implemented
    private var userDefaultsAccessor: UserSessionDataAccessible.Type!
    
    // MARK: - Init / Deinit methods
    init() {
        let userId = userDefaultsAccessor.userId
        if userId > 0 {
            authorizationStatus = .authorized(userId: userId)
        } else {
            authorizationStatus = .notAuthorized
        }
    }
    
    // MARK: - Public methods
    func save(user: User, token: String?) {
        
        UserDefaults.standard.saveUser(user: user)
        if let token = token {
            KeychainManager.shared.saveToken(token: token)
        }
    }
    
    func getUser() -> User? {
        return UserDefaults.standard.getCurrentUser()
    }
}

// MARK: - Authorization status
extension UserSession {
    
    enum AuthorizationStatus {
        case notAuthorized
        case authorized(userId: Int)
    }
}
