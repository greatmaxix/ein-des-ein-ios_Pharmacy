//
//  ChooseLocationViewModel.swift
//  Pharmacy
//
//  Created by Sergey berdnik on 28.10.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation

protocol ChooseLocationViewModelOutput: class {
    func reloadTableViewData(state: Bool)
    func applyTableViewCell(indexPath: IndexPath)
}

protocol ChooseLocationViewModelInput: class {
    var tableViewSections: [TableViewSection] { get }
    var indexForSections: [String] { get }
    func load()
    func close()
    func selected(indexPath: IndexPath)
    var screenState: Bool {get}
    func applyRegion(regionId: Int)
}

class ChooseLocationViewModel: Model {
    
    weak var output: ChooseLocationViewModelOutput!
    private(set) var sections: [TableViewSection] = []
    private var index: [String] = []
    private var searchTerm: String = ""
    
    private let countryProvider = DataManager<LocationAPI, RegionResponse>()
    private let updateUserProvider = DataManager<ProfileAPI, ProfileResponse>()
    
    private var countryResionsData: [Region] = []
    private var state: Bool = false
    
    private lazy var userRegionId: Int = {
        UserDefaultsAccessor.value(for: \.regionId)
    }()
}

// MARK: - ChooseLocationViewModelOutput
extension ChooseLocationViewModel: ChooseLocationViewControllerOutput {}

// MARK: - ChooseLocationViewModelInput
extension ChooseLocationViewModel: ChooseLocationViewModelInput {
    
    var indexForSections: [String] {
        return index
    }
    
    func applyRegion(regionId: Int) {
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
        self.raise(event: EditProfileEvent.profileUpdated)
        self.raise(event: EditProfileEvent.close)
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
            case .failure(let error):
                print("Was error \(error.localizedDescription)")
            }
        }
    }
    
    func close() {
        raise(event: AboutAppEvent.close)
    }
    
    var tableViewSections: [TableViewSection] {
        sections
    }
}

private extension Int {
    static let firstPageSize: Int = 30
    static let pageSize: Int = 10
}
