//
//  WishlistModel.swift
//  Pharmacy
//
//  Created by Mishko on 20.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit
import EventsTree
import Moya

protocol WishlistInput: class {
    
    var wishlistIsEmpty: Bool { get }
    var dataSource: WishlistDataSource { get }
    func load()
    func loadNextPages(lastMedicineIndex: Int)
    func close()
}

protocol WishlistOutput: class {
    func didLoadList()
    func showDeletionError()
}

final class WishlistModel: EventNode {
    
    let dataSource = WishlistDataSource()
    
    private var medicines: [Medicine] = []
    private let provider = DataManager<WishListAPI, WishlistResponse>()
    private var lastPage: Int = 1
    private let medicinesPerPage: Int = 10
    private var loadedAllMedicines: Bool = false
    private var medicinesAreLoading = false
    
    unowned var output: WishlistOutput!
    
    override init(parent: EventNode?) {
        super.init(parent: parent)
        
        dataSource.wishlistDelegate = self
    }
    
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
                self.dataSource.medicines = self.medicines
            case .failure(let error):
                print(error.localizedDescription)
            }
            self.output.didLoadList()
        })
    }
}

extension WishlistModel: WishlistInput {
    
    var wishlistIsEmpty: Bool {
        dataSource.medicines.count == 0
    }
    
    func load() {
        loadMedicines()
    }
    
    func close() {
        raise(event: ProfileEvent.close)
    }
    
    func loadNextPages(lastMedicineIndex: Int) {
        if !loadedAllMedicines,
            lastMedicineIndex > lastPage * medicinesPerPage - 2,
            !medicinesAreLoading {
            
            loadMedicines()
        }
    }
}

extension WishlistModel: WishListEditDelegate {
    
    func selectMedicineAt(index: Int) {
        //
    }
    
    func deleteMedicine(id: Int) {
        
        provider.delete(target: .removeFromWishList(medicineId: id), completion: { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success:
                if self.dataSource.medicines.count == 0 {
                    self.output.didLoadList()
                }
            case .failure:
                self.dataSource.medicines = self.medicines
                self.output.didLoadList()
                self.output.showDeletionError()
            }
        })
    }
}
