//
//  CatalogsModel.swift
//  Pharmacy
//
//  Created by CGI-Kite on 28.07.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import EventsTree

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
    
    let title: String
    
    init(title: String, parent: EventNode?) {
        self.title = title
        super.init(parent: parent)
    }
}

extension CatalogsModel: CatalogsModelInput {
    
    func close() {
        raise(event: CatalogsEvent.close)
    }
    
    internal func load() {
        let category = Category(title: "Название категшории", imageURL: nil)
        let array = Array(repeating: category, count: 9)
        categoryDataSource.cells = array.map { CategoryCellSection.common(category: $0) }
        output.didLoadCategories()
    }
    
    func didSelectCategoryBy(indexPath: IndexPath) {
        guard let cell = categoryDataSource.cell(for: indexPath) else { return }
        switch cell {
        case .common(let category):
            raise(event: CatalogsEvent.openMedicineListFor(category: category))
        }
    }
}
