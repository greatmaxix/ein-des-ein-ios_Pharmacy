//
//  WishlistModel.swift
//  Pharmacy
//
//  Created by CGI-Kite on 20.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit
import EventsTree

protocol WishlistInput: class {
    
    var dataSource: TableDataSource<MedicineCellSection> { get }
    func load()
    func reloadIfNeeded(lastMedicineIndex: Int)
    func close()
}

protocol WishlistOutput: class {
    func didLoadList()
}

final class WishlistModel: EventNode {
    
    private let medicineDataSource = TableDataSource<MedicineCellSection>()
    private let provider = DataManager<WishListAPI, WishlistResponse>()
    private var medicines: [Medicine] = []
    private var lastPage: Int = 0
    private let medicinesPerPage: Int = 10
    private var loadedAllMedicines: Bool = false
    private var medicinesAreLoading = false
    
    unowned var output: WishlistOutput!
    
    private func loadMedicines() {
        
        medicinesAreLoading = true
        provider.load(target: .getWishList(pageNumber: lastPage, medicinesPerPage: medicinesPerPage), completion: { [weak self] result in
            
            guard let self = self else { return }
            self.medicinesAreLoading = false
            
            switch result {
            case .success(let response):
                self.loadedAllMedicines = self.lastPage == response.currentPage
                self.lastPage = response.currentPage
                self.medicines.append(contentsOf: response.medicines)
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
        output.didLoadList()
    }
}

extension WishlistModel: WishlistInput {
    
    var dataSource: TableDataSource<MedicineCellSection> {
        medicineDataSource
    }
    
    func load() {
        loadMedicines()
    }
    
    func close() {
        raise(event: ProfileEvent.close)
    }
    
    func reloadIfNeeded(lastMedicineIndex: Int) {
        if !loadedAllMedicines, lastMedicineIndex > lastPage * medicinesPerPage - 2, !medicinesAreLoading {
            loadMedicines()
        }
    }
}
