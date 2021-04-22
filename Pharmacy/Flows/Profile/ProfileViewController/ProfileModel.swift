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
    case openPrivileges
    case openLanguage
    case logout
    case close
    case openProduct(Medicine)
    case openChooseLocation
    case openChooseDeliveryAdress
    case openAddPrivileges
    case showCancelView
    case openCloseOrder
    case connectWithUs
    case deliveryTutorial

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
    private var user: UserDisplayable?
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
        self.user = UserSession.shared.user

        let openOptionHandler: ((_: ProfileEvent) -> Void) = { [weak self] event in
            self?.raise(event: event)
        }

        cellsData = []

        if UserSession.shared.user != nil {

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
                let cellData: EmptyTableViewCellData = EmptyTableViewCellData(height: 24.5, color: .clear)
                cellsData.append(cellData)
            }

        } else {
            do {
                let cellData = EmptyUserCellData()
                cellData.authorize = { [weak self] in
                    self?.raise(event: ProfileEvent.logout)
                }
                cellData.selectHandler = nil
                cellsData.append(cellData)
            }
        }

        do {
            let location = user?.regionName
            let cellData: ProfileTableViewCellData = ProfileTableViewCellData(title: R.string.localize.profileRegion.localized(), additionalInfo: location, type: .region)
            cellData.image = R.image.profilePin()
            cellData.selectHandler = { [weak self] in
                if UserSession.shared.user != nil {
                    self?.raise(event: ProfileEvent.openChooseLocation)
                }
            }
            cellsData.append(cellData)
        }
        do {
            let cellData: ProfileTableViewCellData = ProfileTableViewCellData(title: R.string.localize.profileLanguage.localized())
            cellData.image = R.image.language_icon()
            cellData.selectHandler = { [weak self] in
                self?.raise(event: ProfileEvent.openLanguage)
            }
            cellsData.append(cellData)
        }

        if UserSession.shared.user != nil {
            do {
                let cellData: ProfileTableViewCellData = ProfileTableViewCellData(title: R.string.localize.profilePayment.localized(), additionalInfo: "1000", type: .payment)
                cellData.image = R.image.profilePayment()
                cellData.selectHandler = { [weak self] in
                    let model = InDevelopmentModel(title: R.string.localize.empty_model_title.localized(), subTitle: R.string.localize.empty_subtitle_title.localized(), image: "inDelivary")
                    self?.raise(event: AppEvent.presentInDev(model))
                }
                cellsData.append(cellData)
            }

            do {
                let cellData: ProfileTableViewCellData = ProfileTableViewCellData(title: R.string.localize.profilePrivileges.localized())
                cellData.image = R.image.prosent_icon()
                cellData.selectHandler = { [weak self] in
                    self?.raise(event: ProfileEvent.openPrivileges)
                }
                cellsData.append(cellData)
            }
            
            do {
                let cellData: ProfileTableViewCellData = ProfileTableViewCellData(title: R.string.localize.profileInsurance.localized())
                cellData.image = R.image.insurance_policy()
                cellData.selectHandler = { [weak self] in
                    let insurnceModel = InDevelopmentModel(title: R.string.localize.empty_insurence_title.localized(), subTitle:R.string.localize.empty_subtitle_title.localized(), image: "empty_Insurance")
                    self?.raise(event: AppEvent.presentInDev(insurnceModel))
                }
                cellsData.append(cellData)
            }
            

            
            do {
                let location = user?.deliveryAddress
                let cellData: ProfileTableViewCellData = ProfileTableViewCellData(title: R.string.localize.profileAddress.localized(), additionalInfo: location, type: .delivery)

                cellData.image = R.image.profileAddress()
                cellData.selectHandler = { [weak self] in
                    self?.raise(event: ProfileEvent.openChooseDeliveryAdress)
                }
                cellsData.append(cellData)
            }
        }

        do {
            let cellData: ProfileTableViewCellData = ProfileTableViewCellData(title: R.string.localize.profileNotifications.localized())
            cellData.image = R.image.profileBellOn()
            cellData.selectHandler = { [weak self] in
                let model = InDevelopmentModel(title: R.string.localize.empty_model_title.localized(), subTitle: R.string.localize.empty_subtitle_title.localized(), image: "inDelivary")
                self?.raise(event: AppEvent.presentInDev(model))
            }
            cellsData.append(cellData)
        }
        do {
            let cellData: EmptyTableViewCellData = EmptyTableViewCellData(height: 32, color: .clear)
            cellsData.append(cellData)
        }
        
        do {
            let cellData: ProfileTableViewCellData = ProfileTableViewCellData(title: R.string.localize.profileCharity.localized())
            cellData.image = R.image.charity()
            cellData.selectHandler = { [weak self] in
                // Благотворительность
//                R.string.localize.emptySu
                let insurnceModel = InDevelopmentModel(title:R.string.localize.empty_charity_title.localized(), subTitle: R.string.localize.empty_subtitle_title.localized(), image: "empty_bell")
                self?.raise(event: AppEvent.presentInDev(insurnceModel))
            }
            cellsData.append(cellData)
        }
        
        
        do {
            let cellData: EmptyTableViewCellData = EmptyTableViewCellData(height: 32, color: .clear)
            cellsData.append(cellData)
        }
        do {
            let cellData: ProfileTableViewCellData = ProfileTableViewCellData(title: R.string.localize.profileAbout.localized())
            cellData.image = R.image.profileAttension()
            
            cellData.selectHandler = { [weak self] in
                self?.raise(event: ProfileEvent.openAbout)
            }
            cellsData.append(cellData)
        }
        do {
            let cellData: ProfileTableViewCellData = ProfileTableViewCellData(title: R.string.localize.profileQuestions.localized())
            cellData.image = R.image.profileQuestion()
            cellData.selectHandler = { [weak self] in
                self?.raise(event: ProfileEvent.openHelp)
            }
            cellsData.append(cellData)
        }
        

        do {
            let cellData: EmptyTableViewCellData = EmptyTableViewCellData(height: 38, color: .clear)
            cellsData.append(cellData)
        }
        do {
            let cellData: ProfileTableViewCellData = ProfileTableViewCellData(title: R.string.localize.profileExit.localized(), type: .exit)
            cellData.image = R.image.profileQuit()
            cellData.selectHandler = { [weak self] in
                self?.output.presentLogoutView()
            }
            cellsData.append(cellData)
        }
        do {
            let cellData: EmptyTableViewCellData = EmptyTableViewCellData(height: 24, color: .clear)
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
        if UserSession.shared.user == nil {
            completion?()
            return
        }

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
            case .success:
                UserSession.shared.logout()
                self.raise(event: ProfileEvent.logout)
            case .failure:
                self.output.showLogoutError()
            }
        })
    }
}
