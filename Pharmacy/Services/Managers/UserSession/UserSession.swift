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
                userEntity = CoreDataService.shared.get(by: userId)
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
    var avatarUUID: String? {
        switch authorizationStatus {
        case .authorized:
            return userEntity.avatar?.uuid
        case .notAuthorized:
            return nil
        }
    }
    var user: UserDisplayable? {
        switch authorizationStatus {
        case .authorized:
            return convertToDisplayable(userEntity: userEntity)
        case .notAuthorized:
            return nil
        }
    }
    
    private var userDefaultsAccessor: UserSessionDataAccessible.Type
    private var userEntity: UserEntity!
    
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
    func save(user: User, token: String?) -> UserDisplayable {
        if let token = token {
            KeychainManager.shared.saveToken(token: token)
        }
        return save(user: user)
    }
    
    @discardableResult
    func save(user: User) -> UserDisplayable {
        CoreDataService.shared.save(user: user)
        userDefaultsAccessor.userId = user.id
        refetchUser()
        
        return UserDisplayable(name: user.name,
                               email: user.email,
                               phone: user.phone,
                               avatarURL: user.avatar?.url)
    }
    
    func save(avatar: AvatarDTO) {
        CoreDataService.shared.save(avatar: avatar, isNeedToSave: false)
        CoreDataService.shared.bindAvatarToUser()
        refetchUser()
    }
}

// MARK: - Private methods
extension UserSession {
    
    private func refetchUser() {
        userEntity = CoreDataService.shared.get(by: userIdentifier)
        NotificationCenter.default.post(Notification.userSesionDidChanged)
    }
    
    private func convertToDisplayable(userEntity: UserEntity) -> UserDisplayable {
        return UserDisplayable(name: userEntity.name,
                               email: userEntity.email,
                               phone: userEntity.phone,
                               avatarURL: userEntity.avatar?.url)
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
