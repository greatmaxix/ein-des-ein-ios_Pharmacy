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
    var favoriteMedicine: [Medicine] { get }
    func load()
    func loadNextPages(lastMedicineIndex: Int)
    func close()
    func selectMedicineAt(index: Int)
    func deleteMedicine(id: Int, index: IndexPath)
}

protocol WishlistOutput: class {
    func didLoadList()
    func showDeletionError()
    func deleteFarovireRow(index: IndexPath)
}

final class WishlistModel: EventNode {
    
    let medicine: [Medicine] = []
    
    private var medicines: [Medicine] = []
    private let provider = DataManager<WishListAPI, WishlistResponse>()
    private var lastPage: Int = 1
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
            self.output.didLoadList()
        })
    }
}

extension WishlistModel: WishlistInput {
    
    var favoriteMedicine: [Medicine] {
        medicines
    }
    
    var wishlistIsEmpty: Bool {
        medicines.count == 0
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
    
    func selectMedicineAt(index: Int) {
        raise(event: MedicineListModelEvent.openProduct(medicines[index]))
    }
    
    func deleteMedicine(id: Int, index: IndexPath) {

        provider.delete(target: .removeFromWishList(medicineId: id), completion: { [weak self] result in
            
            guard let self = self else {return}
            
            switch result {
            case .success:
                if self.medicines.count == 0 {
                    self.output.didLoadList()
                } else {
                    self.medicines.remove(at: index.row)
                    self.output.deleteFarovireRow(index: index)
                }
            case .failure:
                self.output.didLoadList()
                self.output.showDeletionError()
            }
        })
    }
}
