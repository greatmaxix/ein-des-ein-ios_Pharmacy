//
//  ChooseLocationViewModel.swift
//  Pharmacy
//
//  Created by Sergey berdnik on 28.10.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import EventsTree

protocol ChooseLocationViewModelOutput: class {
    func reloadTableViewData(state: Bool)
    func applyTableViewCell(indexPath: IndexPath)
    func searchActionReloading()
}

// MARK: - Configuration enum for ChooseLocationViewModel
enum ChooseLocationViewModelConfuguration {
    case profile
    case onboarding
    
    func getBackButtonTitle() -> String {
        switch self {
        case .profile:
           return R.string.localize.profileProfile()
        case .onboarding:
            return ""
        }
    }
    
    var isProfileConfiguration: Bool {
        switch self {
        case .profile:
            return true
        default:
            return false
        }
    }
}

protocol ChooseLocationViewModelInput: class {
    var tableViewSections: [TableViewSection<Region>] { get }
    var indexForSections: [String] { get }
    func load()
    func close()
    func selected(indexPath: IndexPath)
    var screenState: Bool {get}
    func applyRegion(regionId: Int)
    func startLocationTracking()
    func filterRegions(searchText: String)
    func getNavBarTitle() -> String
    var isProfileConfiguration: Bool { get }
    
}

class ChooseLocationViewModel: Model {
    
    weak var output: ChooseLocationViewModelOutput!
    private(set) var sections: [TableViewSection<Region>] = []
    
    private var backupSection: [TableViewSection<Region>] = []
    private var index: [String] = []
    
    private let countryProvider = DataManager<LocationAPI, RegionResponse>()
    private let updateUserProvider = DataManager<ProfileAPI, ProfileResponse>()
    
    private var configuretion: ChooseLocationViewModelConfuguration!
    
    private var locationService = LocationService()
    
    private var countryResionsData: [Region] = []
    private lazy var debouncer: Executor = .debounce(interval: 0.3)
    
    private var state: Bool = false
    
    // MARK: - init model with parent and confiruration
    init(parent: EventNode?, configuretion: ChooseLocationViewModelConfuguration) {
        super.init(parent: parent)
        self.configuretion = configuretion
    }
    
    private lazy var userRegionId: Int = {
        UserDefaultsAccessor.value(for: \.regionId)
    }()
}

// MARK: - ChooseLocationViewModelOutput
extension ChooseLocationViewModel: ChooseLocationViewControllerOutput {}

// MARK: - ChooseLocationViewModelInput
extension ChooseLocationViewModel: ChooseLocationViewModelInput {
    
    var isProfileConfiguration: Bool {
        return !configuretion.isProfileConfiguration
    }
    
    func getNavBarTitle() -> String {
        configuretion.getBackButtonTitle()
    }
    
    func filterRegions(searchText: String) {
        updateSections(searchText: searchText)
    }
    
    func startLocationTracking() {
        locationService.updateCurrentLocation()
    }
    
    var indexForSections: [String] {
        return index
    }
    
    func applyRegion(regionId: Int) {
        guard self.configuretion == .profile else {
            UserDefaultsAccessor.write(value: regionId, for: \.regionId)
            self.successSaveRegion()
            return
        }
        
        updateUserProvider.load(target: .updateRegion(regionId: regionId)) { result in
            switch result {
            case .success(let user):
                UserSession.shared.save(user: user.user)
                UserDefaultsAccessor.regionId = regionId
                self.successSaveRegion()
            case .failure(let error):
                print("Was error \(error.localizedDescription)")
            }
        }
    }
    
    func successSaveRegion() {
        
        switch configuretion {
        case .profile:
            self.raise(event: EditProfileEvent.profileUpdated)
            self.raise(event: EditProfileEvent.close)
        case .onboarding:
            debouncer.execute {[weak self] in
                self?.raise(event: OnboardingEvent.close)
            }
        case .none:
            break
        }
    }
    
    var screenState: Bool {
            state
        }
    
    func selected(indexPath: IndexPath) {
        self.state = true
        guard !countryResionsData.isEmpty,
            let cities = countryResionsData[indexPath.row].subRegions else {
            self.output.applyTableViewCell(indexPath: indexPath)
            return
        }
        
        self.index.removeAll()
        countryResionsData.removeAll()
        self.sections.removeAll()
        
        let array =  Dictionary(grouping: cities) {$0.name.prefix(1)}
            .sorted(by: { $0.0 < $1.0 })
        
        array.forEach {[weak self] (key, value) in
                self?.index.append(key.description)
                self?.sections.append(TableViewSection(header: key.description, footer: nil, list: value))
        }
        
        self.output.reloadTableViewData(state: false)
    }
    
    func load() {
        countryProvider.load(target: .getRegions(nil, nil)) {[unowned self] (result) in
            switch result {
            case .success(let response):
                
            guard let region = response.regions.first else {return}
                
            self.countryResionsData = region.subRegions!
                
            let array =  Dictionary(grouping: self.countryResionsData) {$0.name.prefix(1)}
                    .sorted(by: { $0.0 < $1.0 })
                        
            array.forEach {[unowned self] (key, value) in
                        self.index.append(key.description)
                        self.sections.append(TableViewSection(header: key.description, footer: nil, list: value))
                }
            self.output.reloadTableViewData(state: state)
            state = false
            self.backupSection = sections
            case .failure(let error):
                print("Was error \(error.localizedDescription)")
            }
        }
    }
    
    func close() {
        switch configuretion {
        case .profile:
            raise(event: AboutAppEvent.close)
        case .onboarding:
            raise(event: OnboardingEvent.closeRegion)
        case .none:
            break
        }
    }
    
    var tableViewSections: [TableViewSection<Region>] {
        sections
    }
    
    private func updateSections(searchText: String) {
        let trimmedTerm = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !trimmedTerm.isEmpty else {
            sections = backupSection
            index.removeAll()
            sections.forEach { index.append($0.header!) }
            self.output.searchActionReloading()
            return }
        
        guard let firstCharacter = trimmedTerm.first?.description else { return }
        
        self.sections = sections.filter({ ($0.header?.lowercased().contains(firstCharacter))!})
        self.index = [firstCharacter.uppercased()]
        self.sections[0].items = sections[0].items.filter({$0.name.lowercased().contains(trimmedTerm.lowercased())})
        
        self.output.searchActionReloading()
    }
}

private extension Int {
    static let firstPageSize: Int = 30
    static let pageSize: Int = 10
}
