//
//  FarmacyListModel.swift
//  Pharmacy
//
//  Created by CGI-Kite on 25.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit
import EventsTree

protocol FarmacyListInput: class {
    var dataSourse: TableDataSource<MapFarmacyCellSection> {get}
      func load()
}

protocol FarmacyListOutput: class {
    
}

class MapFarmacyListModel: EventNode {

    let medicineDataSourse = TableDataSource<MapFarmacyCellSection>()
    private var pharmacies: [PharmacyModel] = []
    
    init(parent: EventNode?, pharmacies: [PharmacyModel]) {
        super.init(parent: parent)
        
        self.pharmacies = pharmacies
    }
    
    unowned var output: FarmacyListOutput!
}

extension MapFarmacyListModel: FarmacyListInput {
    
    var dataSourse: TableDataSource<MapFarmacyCellSection> {
        medicineDataSourse
    }
    
    func load() {
        medicineDataSourse.cells = pharmacies.map({MapFarmacyCellSection.common($0)})
    }
}
