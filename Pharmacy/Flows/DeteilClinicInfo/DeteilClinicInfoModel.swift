//
//  File.swift
//  Pharmacy
//
//  Created by Anna Yatsun on 26.02.2021.
//  Copyright © 2021 pharmacy. All rights reserved.
//


import UIKit

protocol DeteilClinicInfoModelInput: class {
    func load()
    func didSelectCell(at indexPath: IndexPath)
    func close()
    func openDeteilClinic(_ model: TypeOfAnalysis)
    func showAll()
    
    var models: [TypeOfAnalysis] { get }
    var cellHeight: CGFloat { get }
}

protocol DeteilClinicInfoModelOutput: class {
    func didLoad(models: [TypeOfAnalysis])
    func didFetchError(error: Error)
}


final class DeteilClinicInfoModel: Model {
    
    weak var output: DeteilClinicInfoModelOutput!
    
    private let laboratoryProvider = DataManager<DeteilLaboratorAPI, LaboratoryDetailModel>()
    
    private(set) var models: [TypeOfAnalysis] = []
    let cellHeight: CGFloat = 49
}

extension DeteilClinicInfoModel: DeteilClinicInfoControllerOutput {

    
    
    func showAll() {
        //raise(event: AnalysisAndDiagnosticsModelEvent.openAnalisis)
    }
    
    func openDeteilClinic(_ model: TypeOfAnalysis) {
        raise(event: AnalysisAndDiagnosticsModelEvent.openLaboratoryList(model))
    }
    
    
    func close() {
        raise(event: AnalysisAndDiagnosticsModelEvent.back)
    }
    
    func load() {
        let mockData: [TypeOfAnalysis] = [
            .init(analisName: "Лабараторные исследования"),
            .init(analisName: "Отделение ЭКО"),
            .init(analisName: "Массаж"),
            .init(analisName: "Массаж"),
            .init(analisName: "Массаж"),
            .init(analisName: "Массаж"),
            .init(analisName: "Массаж"),
            .init(analisName: "Массаж"),
            .init(analisName: "Массаж"),
            .init(analisName: "Массаж"),
            .init(analisName: "Массаж"),
            .init(analisName: "Массаж")
        ]
        self.models = mockData
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
        raise(event: AnalysisAndDiagnosticsModelEvent.openLaboratoryList(self.models[indexPath.row]))
    }
}
