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
    
//    private let searchDebouncer: Executor
    
    
    override init(parent: EventNode?) {
        super.init(parent: parent)
        
//        searchDebouncer = Executor.debounce(interval: 0.5)
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
            self?.view.searchTermUpdated()
        }
    }
    
    func processSearch() {
        load()
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
