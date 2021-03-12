//
//  LanguageModel.swift
//  Pharmacy
//
//  Created by Anna Yatsun on 10.03.2021.
//  Copyright © 2021 pharmacy. All rights reserved.
//

import Foundation
import EventsTree
import Moya

protocol LanguageViewModelInput: class {
    func load()
    func didSelectCell(at indexPath: IndexPath)
    func close()
    var languageList: [LanguageModel] { get }
}

protocol LanguageViewModelOutput: class {
    func didLoad(models: [LanguageModel])
    func didSelect()
    func didFetchError(error: Error)
}

final class LanguageViewModel: Model {
    weak var output: LanguageViewModelOutput!
    var languageList: [LanguageModel] = []
}

extension LanguageViewModel: LanguageViewControllerOutput {
    
    func close() {
        raise(event: AnalysisAndDiagnosticsModelEvent.back)
    }
    
    func load() {
        let mockData: [LanguageModel] = [
            .init(languageName: "Русский"),
            .init(languageName: "Українська"),
            .init(languageName: "Қазақ"),
            .init(languageName: "O'zbek"),
            .init(languageName: "English")
            
        ]
        self.languageList = mockData
        self.output.didLoad(models: mockData)
    }
    
    func didSelectCell(at indexPath: IndexPath) {
        let model = self.languageList[indexPath.row]
        output.didSelect()
    }
}
