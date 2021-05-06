//
//  File.swift
//  Pharmacy
//
//  Created by Anna Yatsun on 09.03.2021.
//  Copyright © 2021 pharmacy. All rights reserved.
//

import UIKit


protocol QuestionViewModelInput: class {
    func load()
    func didSelectCell(at indexPath: IndexPath)
    func close()
    func showAll()
    
    var selectedModel: QustionModel? { get set }
    var models: [QustionModel] { get }

//    var selectedModels: [QustionModel] { get set }
}

protocol QuestionViewModelOutput: class {
    func didLoad(models: [QustionModel])
    func didFetchError(error: Error)
    
}


final class QuestionViewModel: Model {
    
    weak var output: QuestionViewModelOutput!
    private(set) var models: [QustionModel] = []
    var selectedModel: QustionModel? = nil

}

extension QuestionViewModel: QuestionViewControllerOutput {
    func showAll() {
        raise(event: AnalysisAndDiagnosticsModelEvent.openAnalisis)
    }
    
    func openDeteilClinic(_ model: TypeOfAnalysis) {
        raise(event: AnalysisAndDiagnosticsModelEvent.openLaboratoryList(model))
    }
    
    
    func close() {
        
    }
    
    func load() {
        let mockData: [QustionModel] = [
            .init(image: "busket_icon", name: R.string.localize.how_to_buy.localized(), type: .openInfo),
            .init(image: "duble_back_icon", name: R.string.localize.how_to_return.localized(), type: .openInfo),
            .init(image: "recipient_icon", name: R.string.localize.recipient_question.localized(), type: .openInfo),
            .init(image: "paymet_info_icon", name: R.string.localize.payment_question.localized(), type: .openInfo),
            .init(image: "delivary_icon", name: R.string.localize.delivery_question.localized(), type: .selected),
            .init(image: "write_us_icon", name: R.string.localize.write_us.localized(), type: .selected)
        ]
        self.models = mockData
        output.didLoad(models: models)

    }
    
    func didSelectCell(at indexPath: IndexPath) {

        let model = self.models[indexPath.row]
        if model.type == .selected {
            selectedModel = nil
            if indexPath.row == (self.models.count - 2) {
                raise(event: ProfileEvent.deliveryTutorial)
            }
            
            if indexPath.row == (self.models.count - 1) {
                raise(event: ProfileEvent.connectWithUs)
            }
        } else {
            if selectedModel?.name == model.name {
                self.selectedModel = nil
 
            } else {
//                self.selectedModels.append(model)
                selectedModel = model
            }
        }
    }
}
