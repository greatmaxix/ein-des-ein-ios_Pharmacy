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
    func load()
    func updateSearchTerm(_ term: String)
    func processSearch()
    func cleanStory()
    func didSelectCellAt(indexPath: IndexPath)
}

protocol SearchModelOutput: class {
    func didLoad(story: TableDataSource<SearchCellSection>)
    func didLoad(tags: [String])
}

final class SearchModel: Model {
    
    weak var output: SearchModelOutput!
    
    let storyDataSource = TableDataSource<SearchCellSection>()
    private var searchTerm: String = ""
    private let provider = DataManager<SearchAPI, WishlistResponse>()
    
    private let searchDebouncer: Executor = .debounce(interval: 0.5)
    
    private var data: [Medicine] = []
     
    override init(parent: EventNode?) {
        super.init(parent: parent)
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
        guard let cell = storyDataSource.cell(for: indexPath) else { return }
        
        switch cell {
        case .common:
            raise(event: SearchModelEvent.openList)
        }
    }
    
    func cleanStory() {
        storyDataSource.cells = []
        output.didLoad(story: storyDataSource)
    }
    
    func load() {
        let tags = ["Спазмы", "Головная боль", "Болит живот", "ОРВИ", "Дротаверин", "Ношпа", "Терафлю"]
        output.didLoad(tags: tags)
        
        let stories = ["Дротаверин", "Анфльгин"]
        
        storyDataSource.cells = stories.map { SearchCellSection.common($0) }
        
        output.didLoad(story: storyDataSource)
    }
}

// MARK: - Retrievers
extension SearchModel {
    
    func retreiveMoreMedecines() {
        retreiveMedecines(offset: 0 /*data.count*/) { [weak output] in

        }
    }
    
    private func retreiveMedecines() {
        retreiveMedecines(offset: 0)
    }
    
    private func retreiveMedecines(offset: Int, completion: (() -> Void)? = nil) {
        provider.load(target: .searchByName(name: searchTerm,
                                              regionId: 0,
                                              pageNumber: 1,
                                              itemsOnPage: 10)) { [weak self] response in
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
