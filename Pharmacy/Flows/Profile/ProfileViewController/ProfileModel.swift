//
//  ProfileModel.swift
//  Pharmacy
//
//  Created by CGI-Kite on 24.06.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import EventsTree
import Moya

enum ProfileEvent: Event {
    case editProfile
    case openWishlist
    case openOrder
    case openAnalize
    case openPrescriptions
    case changeRegion
    case openPayment
    case openNotifications
    case openAbout
    case openHelp
    case logout
    case close
}

protocol ProfileInput {
    var cellCount: Int { get }
    func selectActionAt(index: Int) -> EmptyClosure?
    func cellDataAt(index: Int) -> BaseCellData
    func loadUser(completion: EmptyClosure?)
    func logout()
}

protocol ProfileOutput: class {
    func showLogoutError()
    func presentLogoutView()
}

final class ProfileModel: Model {
    
    private var cellsData: [BaseCellData] = []
    private var user: UserDisplayable? = UserSession.shared.user
    private let provider = DataManager<ProfileAPI, ProfileResponse>()
    
    unowned var output: ProfileOutput!

    override init(parent: EventNode?) {
        super.init(parent: parent)
        
        setupDataSource()
        
        addHandler { [weak self] (event: EditProfileEvent) in
            switch event {
            case .profileUpdated:
                self?.setupDataSource()
            default:
                break
            }
        }
    }

    private func setupDataSource() {
        
        let openOptionHandler: ((_: ProfileEvent) -> Void) = { [weak self] event in
            self?.raise(event: event)
        }
        cellsData = []
        do {
            let cellData: NameTableViewCellData = NameTableViewCellData(imageUrl: user?.avatarURL, name: user?.name ?? "Name Surname", phone: user?.phone ?? "+1111111111111")
            cellData.editProfile = { [weak self] in
                self?.raise(event: ProfileEvent.editProfile)
            }
            cellData.selectHandler = nil
            cellsData.append(cellData)
        }
        do {
            let cd: ProfileOptionsCellData = ProfileOptionsCellData()
            cd.events = [ProfileEvent.openWishlist, ProfileEvent.openOrder, ProfileEvent.openAnalize, ProfileEvent.openPrescriptions]
            cd.openProfileOption = openOptionHandler
            cellsData.append(cd)
        }
        do {
            let cellData: EmptyTableViewCellData = EmptyTableViewCellData(height: 24.5)
            cellsData.append(cellData)
        }
        do {
            let cellData: ProfileTableViewCellData = ProfileTableViewCellData(title: R.string.localize.profileRegion(), additionalInfo: "Москва", type: .region)
            cellData.image = R.image.profilePin()
            cellsData.append(cellData)
        }
        do {
            let cellData: ProfileTableViewCellData = ProfileTableViewCellData(title: R.string.localize.profilePayment(), additionalInfo: "1000", type: .payment)
            cellData.image = R.image.profilePayment()
            cellData.selectHandler = { [weak self] in
                self?.raise(event: ProfileEvent.openPayment)
            }
            cellsData.append(cellData)
        }
        do {
            let cellData: ProfileTableViewCellData = ProfileTableViewCellData(title: R.string.localize.profileAddress())
            cellData.image = R.image.profileAddress()
            cellData.selectHandler = { [weak self] in
                self?.raise(event: ProfileEvent.changeRegion)
            }
            cellsData.append(cellData)
        }
        do {
            let cellData: ProfileTableViewCellData = ProfileTableViewCellData(title: R.string.localize.profileNotifications())
            cellData.image = R.image.profileBellOn()
            cellData.selectHandler = { [weak self] in
                self?.raise(event: ProfileEvent.openNotifications)
            }
            cellsData.append(cellData)
        }
        do {
            let cellData: EmptyTableViewCellData = EmptyTableViewCellData(height: 32)
            cellsData.append(cellData)
        }
        do {
            let cellData: ProfileTableViewCellData = ProfileTableViewCellData(title: R.string.localize.profileAbout())
            cellData.image = R.image.profileAttension()
            cellData.selectHandler = { [weak self] in
                self?.raise(event: ProfileEvent.openAbout)
            }
            cellsData.append(cellData)
        }
        do {
            let cellData: ProfileTableViewCellData = ProfileTableViewCellData(title: R.string.localize.profileQuestions())
            cellData.image = R.image.profileQuestion()
            cellData.selectHandler = { [weak self] in
                self?.raise(event: ProfileEvent.openHelp)
            }
            cellsData.append(cellData)
        }
        do {
            let cellData: EmptyTableViewCellData = EmptyTableViewCellData(height: 38)
            cellsData.append(cellData)
        }
        do {
            let cellData: ProfileTableViewCellData = ProfileTableViewCellData(title: R.string.localize.profileExit(), type: .exit)
            cellData.image = R.image.profileQuit()
            cellData.selectHandler = { [weak self] in
                self?.output.presentLogoutView()
            }
            cellsData.append(cellData)
        }
        do {
            let cellData: EmptyTableViewCellData = EmptyTableViewCellData(height: 24)
            cellsData.append(cellData)
        }
    }
}

// MARK: - ProfileInput

extension ProfileModel: ProfileInput {
    
    var cellCount: Int {
        return cellsData.count
    }
    
    func cellDataAt(index: Int) -> BaseCellData {
        return cellsData[index]
    }
    
    func selectActionAt(index: Int) -> EmptyClosure? {
        cellsData[index].selectHandler
    }
    
    func loadUser(completion: EmptyClosure?) {

        provider.load(target: .getCustomer) { [weak self] response in
            guard let self = self else {return}

            switch response {
            case .success(let result):
                self.user = UserSession.shared.save(user: result.user, token: nil)
                self.setupDataSource()
                completion?()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func logout() {
        guard let token = KeychainManager.shared.getToken() else { return }
        
        MoyaProvider<AuthAPI>().request(.logout(refreshToken: token), completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case.success:
                self.raise(event: ProfileEvent.logout)
                UserSession.shared.logout()
            case .failure:
                self.output.showLogoutError()
            }
        })
    }
}
