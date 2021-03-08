//
//  OrderServiceViewModel.swift
//  Pharmacy
//
//  Created by Anna Yatsun on 23.02.2021.
//  Copyright © 2021 pharmacy. All rights reserved.
//

import UIKit

protocol OrderServiceViewModelInput: class {
    func openFilialList()
    func load()
    func didSelectCell(at indexPath: IndexPath)
    func close()
    func addAlert()
    func finishOrder()
    
    var cellHeight: CGFloat { get }
    var selected: PaymentModel? { get set }
    var model: [PaymentModel] { get }
}

protocol OrderServiceViewModelModelOutput: class {
    func didLoad(models: [PaymentModel])
    func didFetchError(error: Error)
}


final class OrderServiceViewModel: Model {
    
    weak var output: OrderServiceViewModelModelOutput!
    private let laboratoryProvider = DataManager<DeteilLaboratorAPI, LaboratoryDetailModel>()
    private var laboratoryList: [LaboratoryDetailModel] = []
    var model: [PaymentModel] = []
    var selected: PaymentModel?
    let cellHeight: CGFloat = 50
}

extension OrderServiceViewModel: OrderServiceVControllerOutput {
    func finishOrder() {
        raise(event: AnalysisAndDiagnosticsModelEvent.finishOrder)
    }
    
    
    func addAlert() {
        raise(event: AnalysisAndDiagnosticsModelEvent.openPromocod)
    }
    

    func load() {
        let mockData: [PaymentModel] = [
            .init(paymetText: "Apple Pay", paymetImage: "appPayNotSelected"),
            .init(paymetText: "Kaspi Bank", paymetImage: "icon_caspy"),
            .init(paymetText: "Страховой полис", paymetImage: "insuranceNotSelected"),
            .init(paymetText: "Наличные", paymetImage: "police_icon_payment"),
        ]
        self.model = mockData
        output.didLoad(models: self.model)
        
        self.laboratoryProvider.load(target: .getLaboratoryList) { [weak self] result in
            switch result {
            case let .success(response):
                debugPrint(response)
            case let .failure(error):
                self?.output.didFetchError(error: error)
            }
        }
    }

    
    func openFilialList() {
        raise(event: AnalysisAndDiagnosticsModelEvent.openFilialList)
    }
    
    func close() {
        raise(event: AnalysisAndDiagnosticsModelEvent.back)
    }
    

    func didSelectCell(at indexPath: IndexPath) {
        let modelValue = model[indexPath.row]
        if selected?.paymetText == modelValue.paymetText {
            self.selected = nil
        } else {
            self.selected = modelValue
        }
    }
    
    
}
