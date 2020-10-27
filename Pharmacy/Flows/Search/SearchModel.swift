//
//  SearchModel.swift
//  Pharmacy
//
//  Created by Anton Bal’ on 07.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import EventsTree
import Moya

enum SearchModelEvent: Event {
    case openList
}

protocol SearchModelInput: class {
    var recentRequests: [String] { get }
    var medicines: [Medicine] { get }
    
    var searchState: SearchModel.SearchState { get }
    
    func retreiveResentRequests()
    func retreiveMoreMedecines()
    func updateSearchTerm(_ term: String)
    func processSearch()
    func cleanSearchTerm()
    func didSelectCellAt(indexPath: IndexPath)
    func addToWishList(productId: Int, indexPath: IndexPath)
    func removeFromWishList(productId: Int, indexPath: IndexPath)
}

protocol SearchModelOutput: class {
    func willSendRequest()
    func didLoadRecentRequests()
    func retrivesNewResults()
    func retreivingMoreMedicinesDidEnd()
    func needToInsertNewMedicines(at: [IndexPath]?)
    func searchTermDidUpdated(_ term: String?)
    func favoriteAciontReloadCell(cellAt: IndexPath)
    func addRemoveFromFavoriteError(indexPath: IndexPath)
}

final class SearchModel: Model {
    
    // MARK: - Properties
    weak var output: SearchModelOutput!
    private(set) var recentRequests: [String] = []
    private(set) var medicines: [Medicine] = []
    var searchState: SearchState {
        guard !searchTerm.isEmpty else {
            return .recents
        }
        
        return medicines.count > 0 ? .found : .empty
    }
    
    private var searchTerm: String = ""
    private let provider = DataManager<SearchAPI, WishlistResponse>()
    private let wishListProvider = DataManager<WishListAPI, PostResponse>()
    
    private let searchDebouncer: Executor = .debounce(interval: 1.0)

    private var pageNumber: Int = 1
    
    private lazy var userRegionId: Int = {
        UserDefaultsAccessor.value(for: \.regionId)
    }()
}

// MARK: - SearchViewControllerOutput
extension SearchModel: SearchViewControllerOutput {
    
    func removeFromWishList(productId: Int, indexPath: IndexPath) {
        wishListProvider.load(target: .removeFromWishList(medicineId: productId)) { (result) in
            switch result {
            case .success:
                self.medicines[indexPath.row].liked = false
                self.output.favoriteAciontReloadCell(cellAt: indexPath)
            case .failure(let error):
                print("error is \(error.localizedDescription)")
                self.output.addRemoveFromFavoriteError(indexPath: indexPath)
                }
        }
    }

    func addToWishList(productId: Int, indexPath: IndexPath) {
        wishListProvider.load(target: .addToWishList(medicineId: productId)) { (result) in
            switch result {
            case .success:
                self.medicines[indexPath.row].liked = true
                self.output.favoriteAciontReloadCell(cellAt: indexPath)
            case .failure(let error):
                print("error is \(error.localizedDescription)")
                self.output.addRemoveFromFavoriteError(indexPath: indexPath)
                }
        }
    }
    
    func updateSearchTerm(_ term: String) {
        let trimmedTerm = term.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard searchTerm != trimmedTerm else {
            return
        }
        
        searchTerm = trimmedTerm
        
        searchDebouncer.execute { [weak self] in
            self?.retreiveMedecines()
        }
    }
    
    func processSearch() {
        searchDebouncer.cancelExecution()
        retreiveMedecines()
    }
    
    func didSelectCellAt(indexPath: IndexPath) {
        switch searchState {
        case .recents:
            searchTerm = recentRequests[indexPath.row]
            output.searchTermDidUpdated(searchTerm)
            retreiveMedecines()
        default:
            return
        }
    }
    
    func cleanSearchTerm() {
        searchDebouncer.cancelExecution()
        retreiveResentRequests()
    }
}

// MARK: - Retrievers
extension SearchModel {
    
    func retreiveResentRequests() {
        recentRequests = ["Дротаверин", "Анальгин", "Адвантан"]
        
        pageNumber = 1
        medicines = []
        searchTerm = ""

        output.didLoadRecentRequests()
    }
    
    func retreiveMoreMedecines() {
        retreiveMedecines(on: pageNumber + 1) { [weak output] in
            output?.retreivingMoreMedicinesDidEnd()
        }
    }
    
    private func retreiveMedecines() {
        pageNumber = 1
        medicines = []
        guard searchTerm != "" else {
            output.didLoadRecentRequests()
            
            return
        }
        
        output.willSendRequest()
        retreiveMedecines(on: pageNumber, pageSize: .firstPageSize)
    }
    
    private func retreiveMedecines(on page: Int,
                                   pageSize: Int = .pageSize,
                                   completion: (() -> Void)? = nil) {
        provider.load(target: .searchByName(name: searchTerm,
                                            regionId: userRegionId,
                                            pageNumber: page,
                                            itemsOnPage: pageSize)) { [weak self] response in
                                                guard let self = self else {
                                                    return
                                                }
                                                
                                                switch response {
                                                case .success(let result):
                                                    self.pageNumber = result.currentPage
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

extension SearchModel {
    
    enum SearchState {
        case recents
        case empty
        case found
    }
}

private extension Int {
    static let firstPageSize: Int = 20
    static let pageSize: Int = 10
}
