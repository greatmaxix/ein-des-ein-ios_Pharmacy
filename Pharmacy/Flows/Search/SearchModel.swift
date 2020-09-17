//
//  SearchModel.swift
//  Pharmacy
//
//  Created by Anton Bal’ on 07.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import EventsTree

enum SearchModelEvent: Event {
    case openList
}

protocol SearchModelInput: class {
    var storyDataSource: TableDataSource<SearchCellSection> { get }
    
    var recentRequests: [String] { get }
    var searchState: SearchModel.SearchState { get }
    
    func retreiveResentRequests()
    func updateSearchTerm(_ term: String)
    func processSearch()
    func cleanStory()
    func didSelectCellAt(indexPath: IndexPath)
}

protocol SearchModelOutput: class {
    func didLoadRecentRequests()
    func retreivingMoreMedicinesDidEnd()
    func didLoad(tags: [String])
}

final class SearchModel: Model {
    
    // MARK: - Properties
    weak var output: SearchModelOutput!
    private(set) var recentRequests: [String] = []
    var searchState: SearchState {
        guard !searchTerm.isEmpty else {
            return .recents
        }
        
        return data.count > 0 ? .found : .empty
    }
    
    let storyDataSource = TableDataSource<SearchCellSection>()
    private var searchTerm: String = ""
    private let provider = DataManager<SearchAPI, WishlistResponse>()
    
    private let searchDebouncer: Executor = .debounce(interval: 0.5)
    
    private var data: [Medicine] = []
    
    private var pageNumber: Int = 1
    
    private lazy var userRegionId: Int = {
        UserDefaultsAccessor.value(for: \.regionId)
    }()
    
    override init(parent: EventNode?) {
        super.init(parent: parent)
        
//        retreiveResentRequests()
    }
}

// MARK: - SearchViewControllerOutput

extension SearchModel: SearchViewControllerOutput {
    
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
//        guard let cell = storyDataSource.cell(for: indexPath) else { return }
        
//        switch cell {
//        case .common:
//            raise(event: SearchModelEvent.openList)
//        }
        switch searchState {
        case .recents:
            searchTerm = recentRequests[indexPath.row]
            // output.searchTermUpdated(searchTerm)
            retreiveMedecines()
        default:
            return
        }
    }
    
    func cleanStory() {
        storyDataSource.cells = []
        output.didLoadRecentRequests()
//        output.didLoad(story: storyDataSource)
    }
}

// MARK: - Retrievers
extension SearchModel {
    
    func retreiveResentRequests() {
//        let tags = ["Спазмы", "Головная боль", "Болит живот", "ОРВИ", "Дротаверин", "Ношпа", "Терафлю"]
//        output.didLoad(tags: tags)
        
        recentRequests = ["Дротаверин", "Анальгин", "Адвантан"]
        
//        storyDataSource.cells = stories.map { SearchCellSection.common($0) }
        
        output.didLoadRecentRequests()
//        output.didLoad(story: storyDataSource)
    }
    
    func retreiveMoreMedecines() {
        pageNumber += 1
        retreiveMedecines(on: pageNumber) { [weak output] in
            output?.retreivingMoreMedicinesDidEnd()
        }
    }
    
    private func retreiveMedecines() {
        pageNumber = 1
        data = []
        retreiveMedecines(on: pageNumber)
    }
    
    private func retreiveMedecines(on page: Int, completion: (() -> Void)? = nil) {
        provider.load(target: .searchByName(name: searchTerm,
                                            regionId: userRegionId,
                                            pageNumber: page,
                                            itemsOnPage: .pageSize)) { [weak self] response in
                                                guard let self = self else {
                                                    return
                                                }
                                                
                                                switch response {
                                                case .success(let result):
                                                    self.data = result.medicines
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
    static let pageSize: Int = 10
}
