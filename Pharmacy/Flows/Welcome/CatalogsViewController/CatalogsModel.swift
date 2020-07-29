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
    
    case openBarCodeReader
    case close
}

protocol CatalogsModelOutput: class {
    
}

protocol CatalogsModelInput: class {
    
    var sectionsCount: Int {get}
    var farmacyCategories: [String] {get}
    
    func rowInSection(section: Int) -> Int
    func cellId(section: Int) -> String
    func objectAt(indexPath: IndexPath) -> Any?
    func cellHeightAt(indexPath: IndexPath) -> CGFloat
    func sectionTitleAt(section: Int) -> String?
    func close()
}

class CatalogsModel: EventNode {
    
    struct TableSection {
        
        let rows: Int
        let title: String?
        let objects: [Any]
        let cellId: String
        let cellHeight: CGFloat
    }
    
    private var categories: [String] = ["category1", "category2", "category3", "category4", "category5", "category6", "category7"]
    private var farmacyName: String? = "Farmacy 01"
    private var sections: [TableSection] = []
    
    func setup(title: String) {
        
        if let farmacyName: String = farmacyName {
            sections.append(TableSection(rows: 1, title: R.string.localize.catalogGood_of_day(), objects: [farmacyName], cellId: "FarmacyCell", cellHeight: 136))
        }
        
        sections.append(TableSection(rows: categories.count, title: nil, objects: categories, cellId: "CatalogsCell", cellHeight: 80))
    }
    
    unowned var output: CatalogsModelOutput!
}

extension CatalogsModel: CatalogsModelInput {
    
    func close() {
        raise(event: CatalogsEvent.close)
    }
    
    func cellHeightAt(indexPath: IndexPath) -> CGFloat {
        return sections[indexPath.section].cellHeight
    }

    func cellId(section: Int) -> String {
        return sections[section].cellId
    }
    
    var sectionsCount: Int {
        return sections.count
    }
    
    var farmacyCategories: [String] {
        return categories
    }
    
    func rowInSection(section: Int) -> Int {
        return sections[section].rows
    }
    
    func objectAt(indexPath: IndexPath) -> Any? {
        return sections[indexPath.section].objects[indexPath.row]
    }
    
    func sectionTitleAt(section: Int) -> String? {
        return sections[section].title
    }

}
