//
//  MedicineListModel.swift
//  Pharmacy
//
//  Created by Anton Bal’ on 12.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import EventsTree

enum MedicineListModelEvent: Event {
    case openProduct(Medicine)
}

protocol MedicineListModelInput: class {
    var medicineDataSource: TableDataSource<MedicineCellSection> { get }
    var title: String { get }
    func load()
    func didSelectProductBy(indexPath: IndexPath)
}

protocol MedicineListModelOutput: class {
    func didLoadList()
}

final class MedicineListModel: Model {
    weak var output: MedicineListModelOutput!
    let medicineDataSource = TableDataSource<MedicineCellSection>()
}

// MARK: - FarmacyListViewControllerOutput

extension MedicineListModel: MedicineListViewControllerOutput {
    func didSelectProductBy(indexPath: IndexPath) {
        guard let cell = medicineDataSource.cell(for: indexPath) else { return }
        
        switch cell {
        case .common(let medicine):
            raise(event: MedicineListModelEvent.openProduct(medicine))
        }
    }
    
    var title: String {
        "Ношпа"
    }
    
    func load() {
        let array = Array(repeating: Medicine(title: "Название товара", price: "568", imageURL: nil), count: 8)
        medicineDataSource.cells = array.map { MedicineCellSection.common($0) }
        
        output.didLoadList()
    }
}
