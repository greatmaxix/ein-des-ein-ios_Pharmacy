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
    private var categories: [Category] = []
    
    let title: String
    
    init(title: String, parent: EventNode?) {
        self.title = R.string.localize.welcomeCategories()
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
//        MoyaProvider<CategoryAPI>().request(.getCategories(startCode: nil, maxLevel: nil), completion: {[weak self] result in
//            switch result {
//            case .success(let response):
//                let arr = try? JSONSerialization.jsonObject(with: response.data, options: .allowFragments) as? [String: Any]
//                print(322)
//            case .failure(let error):
//                print(322)
//            }
//        })
        
        provider.load(target: .getCategories(startCode: nil, maxLevel: nil), completion: { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                var secondLevelCategories: [Category] = []
                
                response.categories.forEach({
                    if let subCategories = $0.subCategories {
                        secondLevelCategories.append(contentsOf: subCategories)
                    }
                })
                self.categories = secondLevelCategories
                self.reloadCategories()
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
        
//        let category = Category(title: "Название категории", imageURL: nil)
//        let array = Array(repeating: category, count: 9)
//        categoryDataSource.cells = array.map { CategoryCellSection.common(category: $0) }
//        output.didLoadCategories()
    }
    
    func didSelectCategoryBy(indexPath: IndexPath) {
        guard let cell = categoryDataSource.cell(for: indexPath) else { return }
        switch cell {
        case .common(let category):
            raise(event: CatalogsEvent.openMedicineListFor(category: category))
        }
    }
}
