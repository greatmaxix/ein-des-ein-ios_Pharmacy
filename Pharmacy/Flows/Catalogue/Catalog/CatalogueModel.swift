//
//  CatalogueModel.swift
//  Pharmacy
//
//  Created by CGI-Kite on 28.07.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import EventsTree
import Moya

enum CatalogueEvent: Event {
    case openMedicineListFor(category: Category)
    case close
}

protocol CatalogueModelOutput: class {
    func didLoadCategories()
    func reloadFiltered()
}

protocol CatalogueModelInput: class {
    var filteredCategories: [Category] { get }
    var categoryDataSource: CollectionDataSource<CategoryCellSection> { get }
    var title: String { get }
    var isSearching: Bool { get }
    func load()
    func close()
    func didSelectCategoryBy(indexPath: IndexPath)
    func didSelectFilteredCategoryBy(indexPath: IndexPath)
    func search(category: String)
    func cleanSearch()
}

class CatalogueModel: Model {
    unowned var output: CatalogueModelOutput!
    let categoryDataSource = CollectionDataSource<CategoryCellSection>()
    let provider = DataManager<CategoryAPI, CategoriesResponse>()
    private var categories: [Category] {
        didSet {
            allCategories = categories.flatMap { $0.allCategories()}
        }
    }
    private var allCategories: [Category] = []
    
    let title: String
    var filteredCategories: [Category] = []
    var searchTerm = ""
    
    init(category: Category? = nil, parent: EventNode?) {
        self.title = category?.shortTitle ?? R.string.localize.welcomeCategories()
        categories = category?.subCategories ?? []
        super.init(parent: parent)
    }
    
    func reloadCategories() {
        categoryDataSource.cells = categories.map({ CategoryCellSection.common(category: $0) })
        output.didLoadCategories()
    }
}

extension CatalogueModel: CatalogueModelInput {
    var isSearching: Bool {
        return false
    }
    
    func close() {
        raise(event: CatalogueEvent.close)
    }
    
    internal func load() {
        
        if categories.count > 0 {
            reloadCategories()
            return
        }
        
        provider.load(target: .getCategories(startCode: nil, maxLevel: nil), completion: { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                self.categories = response.categories
                //response.categories.forEach({print("XXXX - \($0.imageTitle)")})
                self.reloadCategories()
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    func didSelectCategoryBy(indexPath: IndexPath) {
        guard let cell = categoryDataSource.cell(for: indexPath) else { return }
        
        var category: Category!
        
        switch cell {
        case .common(let c): category = c
        }
        
        if category.subCategories?.isEmpty ?? true {
            raise(event: CatalogueEvent.openMedicineListFor(category: category))
        } else {
            raise(event: WelcomeEvent.openCategories(category: category))
        }
    }
    
    func didSelectFilteredCategoryBy(indexPath: IndexPath) {
        let category = filteredCategories[indexPath.row]
        
        if category.subCategories?.isEmpty ?? true {
            raise(event: CatalogueEvent.openMedicineListFor(category: category))
        } else {
            raise(event: WelcomeEvent.openCategories(category: category))
        }
    }
    
    func search(category: String) {
        filteredCategories = allCategories.filter({$0.title.range(of: category, options: .caseInsensitive) != nil})
        output.reloadFiltered()
    }
    
    func cleanSearch() {
        filteredCategories = []
        output.reloadFiltered()
    }
}
