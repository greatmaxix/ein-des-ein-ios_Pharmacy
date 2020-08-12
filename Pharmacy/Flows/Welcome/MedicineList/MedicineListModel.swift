//
//  MedicineListModel.swift
//  Pharmacy
//
//  Created by Anton Bal’ on 12.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import EventsTree

enum MedicineListModelEvent: Event { }

protocol MedicineListModelInput: class {
    var medicineDataSource: TableDataSource<MedicineCellSection> { get }
    var title: String { get }
    func load()
}

protocol MedicineListModelOutput: class {
    func didLoadList()
}

final class MedicineListModel: Model {
    
    weak var output: MedicineListModelOutput!
    let medicineDataSource = TableDataSource<MedicineCellSection>()
}

//MARK: - FarmacyListViewControllerOutput

extension MedicineListModel: MedicineListViewControllerOutput {
    var title: String {
        "Catalouge name"
    }
    
    func load() {
        let array = Array(repeating: Medicine(tittle: "Название товара", price: "568 ₽", imageURL: nil), count: 8)
        medicineDataSource.cells = array.map { MedicineCellSection.common($0) }
        
        output.didLoadList()
    }
}

