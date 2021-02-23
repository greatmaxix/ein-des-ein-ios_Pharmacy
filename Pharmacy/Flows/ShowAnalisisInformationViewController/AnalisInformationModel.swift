//
//  AnalisInformationModel.swift
//  Pharmacy
//
//  Created by Anna Yatsun on 23.02.2021.
//  Copyright © 2021 pharmacy. All rights reserved.
//

import UIKit

protocol AnalisInformationModelInput: class {
    func load()
    func didSelectCell(at indexPath: IndexPath)
    func close()
    func openDeteilClinic(_ model: ClinicModel)
    func orderService()
}

protocol AnalisInformationyModelOutput: class {
    func didLoad(models: [LaboratoryDetailModel])
    func didFetchError(error: Error)
}


final class AnalisInformationModel: Model {
    weak var output: AnalisInformationyModelOutput!
    private let laboratoryProvider = DataManager<DeteilLaboratorAPI, LaboratoryDetailModel>()
    private var laboratoryList: [LaboratoryDetailModel] = []
}

extension AnalisInformationModel: AnalisInformationControllerOutput {
    func orderService() {
        raise(event: AnalysisAndDiagnosticsModelEvent.openOrderService)
    }
    
    func openDeteilClinic(_ model: ClinicModel) {
        //let model = self.laboratoryList[indexPath.row]
        raise(event: AnalysisAndDiagnosticsModelEvent.openClinic(model))
         
    }
    
    
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
