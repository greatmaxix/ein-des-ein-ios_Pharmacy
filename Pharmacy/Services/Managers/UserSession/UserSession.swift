//
//  UserSession.swift
//  Pharmacy
//
//  Created by CGI-Kite on 03.07.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation

extension Notification {
    static let userSesionDidChanged = Notification(name: Notification.Name(rawValue: "userSesionDidChanged"))
}

class UserSession {
    
    // MARK: - Static properties
    static let shared: UserSession = .init()
    
    // MARK: - Properties
    var authorizationStatus: AuthorizationStatus {
        didSet {
            switch authorizationStatus {
            case .notAuthorized:
                clearData()
            case .authorized(let userId):
                userDefaultsAccessor.userId = userId
            }
        }
    }
    var userIdentifier: UInt64 {
        switch authorizationStatus {
        case .authorized(let userId):
            return userId
        case .notAuthorized:
            fatalError("Set `authorizationStatus` as \(String(describing: AuthorizationStatus.authorized)) before")
        }
    }
    var user: UserDisplayable? {
        switch authorizationStatus {
        case .authorized(let userId):
            return nil
//            let user: UserEntity = CoreDataService.shared.get(by: userId) as! UserEntity
        case .notAuthorized:
            return nil
        }
    }
    
    private var userDefaultsAccessor: UserSessionDataAccessible.Type
    
    // MARK: - Init / Deinit methods
    init(with accessor: UserSessionDataAccessible.Type = UserDefaultsAccessor.self) {
        self.userDefaultsAccessor = accessor
        
        let userId = userDefaultsAccessor.userId
        if userId > 0 {
            authorizationStatus = .authorized(userId: userId)
        } else {
            authorizationStatus = .notAuthorized
        }
    }
    
    // MARK: - Public methods
    @discardableResult
    func save(user: User, token: String?) throws -> UserDisplayable {
        if let token = token {
            KeychainManager.shared.saveToken(token: token)
        }
        return try save(user: user)
    }
    
    @discardableResult
    func save(user: User) throws -> UserDisplayable {
//        let userEntity: UserEntity = convertToEntity(user)
        try CoreDataService.shared.save(user)
        userDefaultsAccessor.userId = user.id
        NotificationCenter.default.post(Notification.userSesionDidChanged)
        
        return UserDisplayable(name: "", email: "", phone: "") //convertToDisplayable(userEntity)
    }
}

// MARK: - Private methods
extension UserSession {
    
    private func convertToEntity(_ userDTO: User) -> UserEntity {
        return UserEntity()
    }
    
    private func convertToDisplayable(_ userEntity: UserEntity) -> UserDisplayable {
        return UserDisplayable(name: userEntity.name,
                               email: userEntity.email,
                               phone: userEntity.phone,
                               avatarURL: URL(string: ""))
    }
    
    private func clearData() {
        UserDefaultsAccessor.clear()
    }
}

// MARK: - Authorization status
extension UserSession {
    
    enum AuthorizationStatus {
        case notAuthorized
        case authorized(userId: UInt64)
    }
}
