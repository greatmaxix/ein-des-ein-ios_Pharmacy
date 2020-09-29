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
}

protocol CatalogueModelInput: class {
    var categoryDataSource: CollectionDataSource<CategoryCellSection> { get }
    var title: String { get }
    func load()
    func close()
    func didSelectCategoryBy(indexPath: IndexPath)
}

class CatalogueModel: Model {
    unowned var output: CatalogueModelOutput!
    let categoryDataSource = CollectionDataSource<CategoryCellSection>()
    let provider = DataManager<CategoryAPI, CategoriesResponse>()
    private var categories: [Category]
    
    let title: String
    
    init(category: Category? = nil, parent: EventNode?) {
        self.title = category?.shortTitle ?? R.string.localize.welcomeCategories()
        categories = category?.subCategories ?? []
        super.init(parent: parent)
    }
    
    func reloadCategories() {
        categoryDataSource.cells = categories.map({CategoryCellSection.common(category: $0)})
        output.didLoadCategories()
    }
}

extension CatalogueModel: CatalogueModelInput {
    
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
                var secondLevelCategories: [Category] = []
                
                for category in response.categories {
                    if let subCategories = category.subCategories {
                        secondLevelCategories.append(contentsOf: subCategories)
                    }
                    if category.code != "H" {
                        break
                    }
                }
                self.categories = secondLevelCategories
                self.reloadCategories()
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    func didSelectCategoryBy(indexPath: IndexPath) {
        guard let cell = categoryDataSource.cell(for: indexPath) else { return }
        switch cell {
        case .common(let category):
            if category.subCategories?.isEmpty ?? true {
                raise(event: CatalogueEvent.openMedicineListFor(category: category))
            } else {
                raise(event: WelcomeEvent.openCategories(category: category))
            }
        }
    }
}
