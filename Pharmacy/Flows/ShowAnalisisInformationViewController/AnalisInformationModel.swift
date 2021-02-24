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
    
    var models: [String] { get }
    var cellHeight: CGFloat { get }
}

protocol AnalisInformationyModelOutput: class {
    func didLoad(models: [String])
    func didFetchError(error: Error)
}


final class AnalisInformationModel: Model {
    
    weak var output: AnalisInformationyModelOutput!
    
    private let laboratoryProvider = DataManager<DeteilLaboratorAPI, LaboratoryDetailModel>()
    
    private(set) var models: [String] = []
    let cellHeight: CGFloat = 190
}

extension AnalisInformationModel: AnalisInformationControllerOutput {
    
    
    func orderService() {
        raise(event: AnalysisAndDiagnosticsModelEvent.openOrderService)
    }
    
    func openDeteilClinic(_ model: ClinicModel) {
        raise(event: AnalysisAndDiagnosticsModelEvent.openClinic(model))
    }
    
    
    func close() {
        raise(event: AnalysisAndDiagnosticsModelEvent.back)
    }
    
    func load() {
        models = ["1", "2"]
        output.didLoad(models: models)
        
        self.laboratoryProvider.load(target: .getLaboratoryList) { [weak self] result in
            switch result {
            case let .success(response):
                debugPrint(response)
            case let .failure(error):
                self?.output.didFetchError(error: error)
            }
        }
    }
    
    func didSelectCell(at indexPath: IndexPath) {
        raise(event: AnalysisAndDiagnosticsModelEvent.openAnalisInformation)
    }
}
