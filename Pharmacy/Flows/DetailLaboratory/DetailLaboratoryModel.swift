//
//  DetailLaboratoryModel.swift
//  Pharmacy
//
//  Created by Anna Yatsun on 19.02.2021.
//  Copyright © 2021 pharmacy. All rights reserved.
//

import Foundation

protocol DetailLaboratoryModelInput: class {
    func load()
    func didSelectCell(at indexPath: IndexPath)
    func close()
}

protocol DetailLaboratoryModelOutput: class {
    func didLoad(models: [LaboratoryDetailModel])
    func didFetchError(error: Error)
}


final class DeteilLaboratoryyModel: Model {
    weak var output: DetailLaboratoryModelOutput!
    private let laboratoryProvider = DataManager<DeteilLaboratorAPI, LaboratoryDetailModel>()
    private var laboratoryList: [LaboratoryDetailModel] = []
}
//
////
extension DeteilLaboratoryyModel: DeteilLaboratoryControllerOutput {
    
    func close() {
        raise(event: AnalysisAndDiagnosticsModelEvent.back)
    }
    
    func load() {
        let mockData: [LaboratoryDetailModel] = [
            .init(analisName: "Биохимические исследования", countOfDay: "54"),
            .init(analisName: "Гематологические исследования", countOfDay: "54"),
            .init(analisName: "Гармональные исследования", countOfDay: "54")
        ]
        self.laboratoryList = mockData
        self.output.didLoad(models: mockData)
        
        self.laboratoryProvider.load(target: .getLaboratoryList) { [weak self] result in
            switch result {
            case let .success(response):
                let model = LaboratoryDetailModel(analisName: response.analisName ?? "", countOfDay: response.countOfDay ?? "")
                self?.output.didLoad(models: [model])
            case let .failure(error):
                self?.output.didFetchError(error: error)
            }
        }
    }
    
    func didSelectCell(at indexPath: IndexPath) {
        let model = self.laboratoryList[indexPath.row]
        raise(event: AnalysisAndDiagnosticsModelEvent.openAnalisInformation)
    }
}
