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
    var totalNumberOfItems: Int { get }
    func load()
    func didSelectProductBy(indexPath: IndexPath)
}

protocol MedicineListModelOutput: class {
    func retrivesNewResults()
    func retreivingMoreMedicinesDidEnd()
    func needToInsertNewMedicines(at: [IndexPath]?)
}

final class MedicineListModel: Model {
    
    // MARK: - Properties
    weak var output: MedicineListModelOutput!
    
    let medicineDataSource = TableDataSource<MedicineCellSection>()
    private(set) var medicines: [Medicine] = []
    private(set) var totalNumberOfItems: Int = 0
    var title: String {
        self.category?.shortTitle ?? R.string.localize.welcomeCategories()
    }
    
    private var category: Category?
    private let provider = DataManager<SearchAPI, WishlistResponse>()
    private var pageNumber: Int = 1
    
    private lazy var userRegionId: Int = {
        UserDefaultsAccessor.value(for: \.regionId)
    }()
    
    // MARK: - Init / Deinit methods
    init(category: Category? = nil, parent: EventNode?) {
        self.category = category
        super.init(parent: parent)
    }
}

// MARK: - Private methods
extension MedicineListModel {
    func retreiveMoreMedecines() {
        retreiveMedecines(on: pageNumber + 1) { [weak output] in
            output?.retreivingMoreMedicinesDidEnd()
        }
    }
    
    private func retreiveMedecines() {
        pageNumber = 1
        medicines = []
        retreiveMedecines(on: pageNumber, pageSize: .firstPageSize)
    }
    
    private func retreiveMedecines(on page: Int,
                                   pageSize: Int = .pageSize,
                                   completion: (() -> Void)? = nil) {
        provider.load(target: .searchByName(name: "",
                                            regionId: userRegionId,
                                            categoryCode: category?.code,
                                            pageNumber: page,
                                            itemsOnPage: pageSize)) { [weak self] response in
                                                guard let self = self else {
                                                    return
                                                }
                                                
                                                switch response {
                                                case .success(let result):
                                                    self.pageNumber = result.currentPage
                                                    self.totalNumberOfItems = result.totalNumberOfItems
                                                    self.medicines.append(contentsOf: result.medicines)
                                                    if self.pageNumber == 1 {
                                                        self.output.retrivesNewResults()
                                                    } else if self.pageNumber > 1 {
                                                        let startIndex = self.medicines.count - result.medicines.count
                                                        let endIndex = startIndex + result.medicines.count
                                                        let indexPathesToInsert = (startIndex..<endIndex).map {
                                                            IndexPath(row: $0, section: 0)
                                                        }
                                                        
                                                        self.output.needToInsertNewMedicines(at: indexPathesToInsert)
                                                    }
                                                case .failure(let error):
                                                    print(error.localizedDescription)
                                                }
                                                
                                                completion?()
        }
    }
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
    
    func load() {
        retreiveMedecines()
    }
}

private extension Int {
    static let firstPageSize: Int = 20
    static let pageSize: Int = 10
}
