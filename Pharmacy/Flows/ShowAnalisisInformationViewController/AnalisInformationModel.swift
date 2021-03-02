//
//  AnalisInformationModel.swift
//  Pharmacy
//
//  Created by Anna Yatsun on 23.02.2021.
//  Copyright © 2021 pharmacy. All rights reserved.
//

import UIKit

protocol AnalisInformationModelInput: class {
    func openFilialList()
    func load()
    func didSelectCell(at indexPath: IndexPath)
    func close()
    func openDeteilClinic(_ model: ClinicModel)
    func orderService()
    
    var models: [ClinicModel] { get }
    var cellHeight: CGFloat { get }
}

protocol AnalisInformationyModelOutput: class {
    func didLoad(models: [ClinicModel])
    func didFetchError(error: Error)
}


final class AnalisInformationModel: Model {
    
    weak var output: AnalisInformationyModelOutput!
    
    private let laboratoryProvider = DataManager<DeteilLaboratorAPI, LaboratoryDetailModel>()
    
    var models: [ClinicModel] = []
    let cellHeight: CGFloat = 190
}

extension AnalisInformationModel: AnalisInformationControllerOutput {
    
    func openFilialList() {
        raise(event: AnalysisAndDiagnosticsModelEvent.openFilialList)
    }
    
    
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
        let mockData: [ClinicModel] = [
            .init(clinicName: "Инвитро", adressClinic: "ул Горная 23а, Харьков", imageClinic: "logo_invitro", priceClinic: "568 ₸  ", phoneNumber: "📞️ +7 (098) 000 02 00 • +7 (098) 000 02 00"),
            .init(clinicName: "Синево", adressClinic: "ул Горная 23а, Харьков", imageClinic: "logo_seneva", priceClinic: "568 ₸  ", phoneNumber: "📞️ +7 (098) 000 02 00 • +7 (098) 000 02 00")
        ]
        self.models = mockData
        output.didLoad(models: self.models)
        
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

    }
}
