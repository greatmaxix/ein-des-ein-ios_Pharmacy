//
//  AnalysisAndDiagnosticsModel.swift
//  Pharmacy
//
//  Created by Anna Yatsun on 18.02.2021.
//  Copyright © 2021 pharmacy. All rights reserved.
//

import Foundation
import EventsTree
import CoreLocation

enum AnalysisAndDiagnosticsModelEvent: Event {
    case openAnalysis(TypeOfAnalysis)
    case openLaboratory(TypeOfAnalysis)
    case backToAnalisis
}

protocol AnalysisAndDiagnosticsModelInput: class {
    func load()
    func didSelectCell(at indexPath: IndexPath)
}

protocol AnalysisAndDiagnosticsModelOutput: class {
    func didLoad(models: [TypeOfAnalysis])
    func didFetchError(error: Error)
}

final class AnalysisAndDiagnosticsModel: Model {
    
    weak var output: AnalysisAndDiagnosticsModelOutput!
    private let analisisListProvider = DataManager<AnalisisListAPI, AnalisisAndDiagnosResponse>()
    private var typesOfAnalysis: [TypeOfAnalysis] = []
}

// MARK: - AnalysisAndDiagnosticsModelOutput

extension AnalysisAndDiagnosticsModel: AnalysisAndDiagnosticsControllerOutput {
    
    func load() {
        let mockData: [TypeOfAnalysis] = [
            .init(analisName: "Лабараторные исследования"),
            .init(analisName: "Отделение ЭКО"),
            .init(analisName: "Массаж")
        ]
        self.output.didLoad(models: mockData)
        self.typesOfAnalysis = mockData
        
        self.analisisListProvider.load(target: .getAnalis) { [weak self] result in
            switch result {
            case let .success(response):
                self?.typesOfAnalysis = response.item
                self?.output.didLoad(models: response.item)
            case let .failure(error):
                self?.output.didFetchError(error: error)
            }
        }
    }
    
    func didSelectCell(at indexPath: IndexPath) {
        let model = self.typesOfAnalysis[indexPath.row]
        self.raise(event: AnalysisAndDiagnosticsModelEvent.openAnalysis(model))
    }
}
