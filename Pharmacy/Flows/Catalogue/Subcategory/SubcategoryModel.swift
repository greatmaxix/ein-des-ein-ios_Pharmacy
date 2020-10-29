//
//  SubcategoryModel.swift
//  Pharmacy
//
//  Created by Egor Bozko on 29.10.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import EventsTree
import Moya

enum SubcategoryEvent: Event {
    case openMedicineListFor(category: Category)
    case close
}

protocol SubcategoryModelOutput: class {
    func didLoadCategories()
}

protocol SubcategoryModelInput: class {
    var categoryDataSource: TableDataSource<SubcategoryCellSection> { get }
    var title: String { get }
    func load()
    func close()
    func didSelectCategoryBy(indexPath: IndexPath)
}

class SubcategoryModel: Model {
    unowned var output: SubcategoryModelOutput!
    let categoryDataSource = TableDataSource<SubcategoryCellSection>()
    let provider = DataManager<CategoryAPI, CategoriesResponse>()
    private var categories: [Category]
    
    let title: String
    
    init(category: Category? = nil, parent: EventNode?) {
        self.title = category?.shortTitle ?? R.string.localize.welcomeCategories()
        categories = category?.subCategories ?? []
        super.init(parent: parent)
    }
    
    func reloadCategories() {
        categoryDataSource.cells = categories.map({SubcategoryCellSection.common($0)})
        output.didLoadCategories()
    }
}

extension SubcategoryModel: SubcategoryModelInput {
    
    func close() {
        raise(event: CatalogueEvent.close)
    }
    
    internal func load() {
        if categories.count > 0 {
            reloadCategories()
            return
        }
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
}
