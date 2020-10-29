//
//  ChooseLocationViewModel.swift
//  Pharmacy
//
//  Created by Sergey berdnik on 28.10.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation

protocol ChooseLocationViewModelOutput: class {
    func reloadTableViewData()
}

protocol ChooseLocationViewModelInput: class {
    var tableViewSections: [TableViewSection] { get }
    func load()
    func close()
    func selected(indexPath: IndexPath)
}

class ChooseLocationViewModel: Model {
    weak var output: ChooseLocationViewModelOutput!
    private(set) var sections: [TableViewSection] = []
    private var searchTerm: String = ""
    private let cityProvider = DataManager<SearchAPI, WishlistResponse>()
    
    private let countryProvider = DataManager<LocationAPI, RegionResponse>()
    private var pageNumber: Int = 1
    
    private var countryResionsData: [Region] = []
    
    private lazy var userRegionId: Int = {
        UserDefaultsAccessor.value(for: \.regionId)
    }()
}

// MARK: - ChooseLocationViewModelOutput
extension ChooseLocationViewModel: ChooseLocationViewControllerOutput {

}

// MARK: - ChooseLocationViewModelInput
extension ChooseLocationViewModel: ChooseLocationViewModelInput {
    
    func selected(indexPath: IndexPath) {
        let test = countryResionsData[indexPath.row].subRegions
        test?.forEach({print("zxcv \($0.name)")})
    }
    
    func load() {
        countryProvider.load(target: .getRegions(nil, nil)) { (result) in
            switch result {
            case .success(let response):
                guard let region = response.regions.first else {return}
                self.countryResionsData = region.subRegions!
                let array =  Dictionary(grouping: self.countryResionsData) {$0.name.prefix(1)}
                    .sorted(by: { $0.0 < $1.0 })
                        
                array.forEach { (key, value) in
                        self.sections.append(TableViewSection(header: key.description, footer: nil, list: value))
                }

                self.output.reloadTableViewData()
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
