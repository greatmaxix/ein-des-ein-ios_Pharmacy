//
//  OrderServiceViewModel.swift
//  Pharmacy
//
//  Created by Anna Yatsun on 23.02.2021.
//  Copyright © 2021 pharmacy. All rights reserved.
//

import Foundation

protocol OrderServiceViewModelInput: class {
    func load()
    func didSelectCell(at indexPath: IndexPath)
    func close()
}

protocol OrderServiceViewModelModelOutput: class {
    func didLoad(models: [LaboratoryDetailModel])
    func didFetchError(error: Error)
}


final class OrderServiceViewModel: Model {
    
    weak var output: OrderServiceViewModelModelOutput!
    private let laboratoryProvider = DataManager<DeteilLaboratorAPI, LaboratoryDetailModel>()
    private var laboratoryList: [LaboratoryDetailModel] = []
}

extension OrderServiceViewModel: OrderServiceVControllerOutput {
    
    func close() {
        raise(event: AnalysisAndDiagnosticsModelEvent.back)
    }
    
    func load() {
        output.didLoad(models: [])
    }
    
    func didSelectCell(at indexPath: IndexPath) {
        raise(event: AnalysisAndDiagnosticsModelEvent.openAnalisInformation)
    }
}
