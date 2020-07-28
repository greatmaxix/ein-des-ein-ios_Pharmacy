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
    
    case openMap
    case openBarCodeReader
}

protocol CatalogsModelOutput: class {
    
    func showReadyOrders(orders: [String])
}

protocol CatalogsModelInput: class {
    var sectionsCount: Int {get}
    var farmacyCategories: [String] {get}
    func rowInSection(section: Int) -> Int
    func cellId(section: Int) -> String
    func objectAt(indexPath: IndexPath)-> Any?
}

class CatalogsModel: EventNode {
    
    struct TableSection {
        
        let rows: Int
        let title: String?
        let objects: [Any]
        let cellId: String
    }
    
    private var categories: [String] = ["category1", "category2", "category3", "category4", "category5"]
    private var farmacyName: String?
    private var sections: [TableSection] = []
    
    func setup(title: String) {
        
        sections = [TableSection(rows: categories.count, title: nil, objects: categories, cellId: "FarmacyCell")]
        if let farmacyName: String = farmacyName {
            sections.append(TableSection(rows: 1, title: "Goods of day", objects: [farmacyName], cellId: "CatalogsCell"))
        }
    }
    
    unowned var output: CatalogsModelOutput!
}

extension CatalogsModel: CatalogsModelInput {

    func cellId(section: Int) -> String {
        return sections[section].cellId
    }
    
    var sectionsCount: Int {
        return sections.count
    }
    
    var farmacyCategories: [String] {
        return categories
    }
    
    func rowInSection(section: Int)-> Int {
        return sections[section].rows
    }
    
    func objectAt(indexPath: IndexPath) -> Any? {
        return sections[indexPath.section].objects[indexPath.row]
    }
}
