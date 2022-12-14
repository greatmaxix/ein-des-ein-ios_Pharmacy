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
    var isAuthorized: Bool {
        switch authorizationStatus {
        case .authorized:
            return true
        default:
            return false
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
    var avatarUUID: String? {
        switch authorizationStatus {
        case .authorized:
            return userEntity.avatar?.uuid
        case .notAuthorized:
            return nil
        }
    }
    var userUUID: String? {
        switch authorizationStatus {
        case .authorized:
            return userEntity.uuid
        case .notAuthorized:
            return nil
        }
    }
    
    var userRegionId: Int64? {
        switch authorizationStatus {
        case .authorized:
            return userEntity.region?.id
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
    
    var recentMedicineViewed: [RecentMedicineDTO] {
        return medicineViewed
    }
    
    private var userDefaultsAccessor: UserSessionDataAccessible.Type
    private var userEntity: UserEntity!
    private var medicineViewed: [RecentMedicineDTO] = []
    
    // MARK: - Init / Deinit methods
    init(with accessor: UserSessionDataAccessible.Type = UserDefaultsAccessor.self) {
        self.userDefaultsAccessor = accessor
        
        let userId = userDefaultsAccessor.userId
        if userId > 0 {
            authorizationStatus = .authorized(userId: userId)
            userEntity = CoreDataService.shared.get(by: userId)
            medicineViewed = CoreDataService.shared.getRecentMedicine()!
        } else {
            authorizationStatus = .notAuthorized
        }
    }
    
    // MARK: - Public methods
    @discardableResult
    func save(user: UserDTO, token: String?) -> UserDisplayable {
        if let token = token {
            KeychainManager.shared.saveToken(token: token)
        }
        return save(user: user)
    }
    
    @discardableResult
    func save(user: UserDTO) -> UserDisplayable {
        CoreDataService.shared.save(user: user)
        userDefaultsAccessor.userId = user.id
        refetchUser()
        
        return UserDisplayable(name: user.name,
                               uuid: user.uuid,
                               email: user.email,
                               phone: user.phone,
                               avatarURL: user.avatar?.url,
                               regionName: user.region?.name,
                               deliveryAddress: user.deliveryAddress?.street,
                               regionId: user.region?.id,
                               topicName: user.topicName)
    }
    
    func save(avatar: AvatarDTO) {
        CoreDataService.shared.save(avatar: avatar, isNeedToSave: false)
        CoreDataService.shared.bindAvatarToUser()
        refetchUser()
    }
    
    func save(region: RegionDTO) {
        CoreDataService.shared.save(region: region, isNeedToSave: false)
        CoreDataService.shared.bindRegionToUser()
        refetchUser()
    }
    
    func save(deliveryAddress: DeliveryAddressDTO) {
        CoreDataService.shared.save(address: deliveryAddress, isNeedToSave: false)
        CoreDataService.shared.bindDeliveryAddressToUser()
        refetchUser()
    }
    
    func save(medicine: RecentMedicineDTO) {
        CoreDataService.shared.save(medicine: medicine)
        medicineViewed.append(medicine)
    }
    
    func logout() {
        authorizationStatus = .notAuthorized
        userDefaultsAccessor.clear()
        CoreDataService.shared.renewingCoreData()
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
                               uuid: userEntity.uuid,
                               email: userEntity.email,
                               phone: userEntity.phone,
                               avatarURL: userEntity.avatar?.url,
                               regionName: userEntity.region?.name,
                               deliveryAddress: userEntity.deliveryAdress?.street,
                               regionId: userEntity.region?.id,
                               topicName: userEntity.topicName)
    }

    private func clearData() {
        UserDefaultsAccessor.clear()
        KeychainManager.shared.saveToken(token: "")
    }
}

// MARK: - Authorization status
extension UserSession {
    
    enum AuthorizationStatus {
        case notAuthorized
        case authorized(userId: Int)
    }
}
