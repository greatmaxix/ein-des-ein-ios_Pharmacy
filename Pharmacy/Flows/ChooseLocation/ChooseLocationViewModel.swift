//
//  ChooseLocationViewModel.swift
//  Pharmacy
//
//  Created by Sergey berdnik on 28.10.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation

protocol ChooseLocationViewModelOutput: class {
    
}

protocol ChooseLocationViewModelInput: class {
    var tableViewSections: [TableViewSection] { get }
    func close()
}

class ChooseLocationViewModel: Model {
    weak var output: ChooseLocationViewModelOutput!
    private(set) var sections: [TableViewSection] = []
    private var searchTerm: String = ""
    private let cityProvider = DataManager<SearchAPI, WishlistResponse>()
    
    private var pageNumber: Int = 1
    
    private lazy var userRegionId: Int = {
        UserDefaultsAccessor.value(for: \.regionId)
    }()
}

// MARK: - ChooseLocationViewModelOutput
extension ChooseLocationViewModel: ChooseLocationViewControllerOutput {

}

// MARK: - ChooseLocationViewModelInput
extension ChooseLocationViewModel: ChooseLocationViewModelInput {
    func close() {
        raise(event: AboutAppEvent.close)
    }
    
    var tableViewSections: [TableViewSection] {
        sections
    }
}
