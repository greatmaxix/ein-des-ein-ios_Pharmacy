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
import Rswift

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
        let languageNames: [LanguageNames] = LanguageNames.allCases
        let mockData: [LanguageModel] = languageNames.map { LanguageModel(name: $0) }
        self.languageList = mockData
        self.output.didLoad(models: mockData)
    }
    
    func didSelectCell(at indexPath: IndexPath) {
//        R.
        let model = self.languageList[indexPath.row]
        LanguageService.current.saveLanguageModel(model)
        output.didSelect()
    }
}

extension StringResource {
    
    public func localized() -> String {
        let code = LanguageService.current.getCurrentLanguageModel().languageCode
        
        return self.localized(code)
    }
    
    public func localized(_ language: String) -> String {
        guard
            let basePath = bundle.path(forResource: "Base", ofType: "lproj"),
            let baseBundle = Bundle(path: basePath)
        else {
            return self.key
        }
        
        let fallback = baseBundle.localizedString(forKey: key, value: key, table: tableName)
        
        guard
            let localizedPath = bundle.path(forResource: language, ofType: "lproj"),
            let localizedBundle = Bundle(path: localizedPath)
        else {
            return fallback
        }
        
        return localizedBundle.localizedString(forKey: key, value: fallback, table: tableName)
    }
}
