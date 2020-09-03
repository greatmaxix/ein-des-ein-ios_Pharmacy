//
//  CatalogsModel.swift
//  Pharmacy
//
//  Created by CGI-Kite on 28.07.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import EventsTree
import Moya

enum CatalogsEvent: Event {
    
    case openMedicineListFor(category: Category)
    case close
}

protocol CatalogsModelOutput: class {
    func didLoadCategories()
}

protocol CatalogsModelInput: class {
    var categoryDataSource: CollectionDataSource<CategoryCellSection> { get }
    var title: String { get }
    func load()
    func close()
    func didSelectCategoryBy(indexPath: IndexPath)
}

class CatalogsModel: EventNode {
    unowned var output: CatalogsModelOutput!
    let categoryDataSource = CollectionDataSource<CategoryCellSection>()
    let provider = DataManager<CategoryAPI, CategoriesResponse>()
    private var categories: [Category]
    
    
    let title: String
    
    init(category: Category?, parent: EventNode?) {
        self.title = category?.title ?? R.string.localize.welcomeCategories()
        categories = category?.subCategories ?? []
        super.init(parent: parent)
    }
    
    func reloadCategories() {
        categoryDataSource.cells = categories.map({CategoryCellSection.common(category: $0)})
        output.didLoadCategories()
    }
}

extension CatalogsModel: CatalogsModelInput {
    
    func close() {
        raise(event: CatalogsEvent.close)
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
            if let count = category.subCategories?.count, count > 0 {
                raise(event: WelcomeEvent.openCategories(category: category))
            } else {
                raise(event: CatalogsEvent.openMedicineListFor(category: category))
            }
        }
    }
}
