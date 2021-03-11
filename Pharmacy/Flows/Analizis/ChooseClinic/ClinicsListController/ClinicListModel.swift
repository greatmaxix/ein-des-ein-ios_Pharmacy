//  ChooseClinicModel.swift
//  Pharmacy
//
//  Created by Anna Yatsun on 01.03.2021.
//  Copyright © 2021 pharmacy. All rights reserved.
//

import UIKit

protocol ClinicListModellInput: class {
    func load()
    func didSelectCell(at indexPath: IndexPath)
    func close()
    func showOnMap(model: ClinicModel)
    func showOrder(model: ClinicModel)
    func openDeteilClinic(_ model: ClinicModel)
    
    var clinicModelList: [ClinicModel] { get }
}

protocol ClinicListModelOutput: class {
    func didLoad(models: [ClinicModel])
    func didFetchError(error: Error)
}


final class ClinicListModel: Model {
    weak var output: ClinicListModelOutput!
    private let clinicModel = DataManager<ChoseClinicAPI, ClinicModel>()
    var clinicModelList: [ClinicModel] = []
}

extension ClinicListModel: ClinicsListControllerOutput {
    
    func close() {
        raise(event: AnalysisAndDiagnosticsModelEvent.back)
    }
    
    func load() {
        let mockData: [ClinicModel] = [
            .init(clinicName: "Инвитро", adressClinic: "ул Горная 23а, Харьков", imageClinic: "logo_invitro", priceClinic: "568 ₸  ", phoneNumber: "📞️ +7 (098) 000 02 00 • +7 (098) 000 02 00"),
            .init(clinicName: "Синево", adressClinic: "ул Горная 23а, Харьков", imageClinic: "logo_seneva", priceClinic: "568 ₸  ", phoneNumber: "📞️ +7 (098) 000 02 00 • +7 (098) 000 02 00"),
            .init(clinicName: "Синево", adressClinic: "ул Горная 23а, Харьков", imageClinic: "logo_seneva", priceClinic: "568 ₸  ", phoneNumber: "📞️ +7 (098) 000 02 00 • +7 (098) 000 02 00"),
            .init(clinicName: "Синево", adressClinic: "ул Горная 23а, Харьков", imageClinic: "logo_seneva", priceClinic: "568 ₸  ", phoneNumber: "📞️ +7 (098) 000 02 00 • +7 (098) 000 02 00")
        ]
        self.clinicModelList = mockData
        self.output.didLoad(models: self.clinicModelList)
        
        self.clinicModel.load(target: .getClinicLict) { [weak self] result in
            switch result {
            case let .success(response):
                let model = ClinicModel(clinicName: "Инвитро", adressClinic: "ул Горная 23а, Харьков", imageClinic: "logo_invitro", priceClinic: "568 ₸  ", phoneNumber: "📞️ +7 (098) 000 02 00 • +7 (098) 000 02 00")
                self?.output.didLoad(models: [model])
            case let .failure(error):
                self?.output.didFetchError(error: error)
            }
        }
    }
    
    func showOrder(model: ClinicModel) {
        raise(event: AnalysisAndDiagnosticsModelEvent.openOrderService(model))
    }
    
    func showOnMap(model: ClinicModel) {
        raise(event: AnalysisAndDiagnosticsModelEvent.showOnMap(model))
    }
    
    func openDeteilClinic(_ model: ClinicModel) {
        raise(event: AnalysisAndDiagnosticsModelEvent.openClinic(model))
    }
    
    func didSelectCell(at indexPath: IndexPath) {
        let model = self.clinicModelList[indexPath.row]
        raise(event: AnalysisAndDiagnosticsModelEvent.openAnalisInformation)
    }
}
