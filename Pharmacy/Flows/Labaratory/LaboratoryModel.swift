//
//  LaboratoryModel.swift
//  Pharmacy
//
//  Created by Anna Yatsun on 18.02.2021.
//  Copyright © 2021 pharmacy. All rights reserved.
//

import Foundation

protocol LaboratoryModelInput: class {
    func load()
    func didSelectCell(at indexPath: IndexPath)
}

protocol LaboratoryModelOutput: class {
    func didLoad(models: [LaboratoryResearchModel])
    func didFetchError(error: Error)
}


final class LaboratoryModel: Model {
    weak var output: LaboratoryModelOutput!
    private let laboratoryProvider = DataManager<LaboratoryListAPI, LaboratoryResponse>()
    private var laboratoryList: [LaboratoryResearchModel] = []
}

extension LaboratoryModel: LaboratoryControllerOutput {
    func load() {
        let mockData: [LaboratoryResearchModel] = [
            .init(laboratoryName: "Биохимические исследования"),
            .init(laboratoryName: "Гематологические исследования"),
            .init(laboratoryName: "Гармональные исследования")
        ]
        self.laboratoryList = mockData
        self.output.didLoad(models: mockData)
        
        self.laboratoryProvider.load(target: .getLaboratoryList) { [weak self] result in
            switch result {
            case let .success(response):
                self?.laboratoryList = response.laboratory
                self?.output.didLoad(models: response.laboratory)
            case let .failure(error):
                self?.output.didFetchError(error: error)
            }
        }
    }
    
    func didSelectCell(at indexPath: IndexPath) {
        let model = self.laboratoryList[indexPath.row]
    //    self.raise(event: AnalysisAndDiagnosticsModelEvent.openAnalysis(model))
    }

}
