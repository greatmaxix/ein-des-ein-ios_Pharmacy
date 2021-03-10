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
    
    var models: [QustionModel] { get }

}

protocol QuestionViewModelOutput: class {
    func didLoad(models: [QustionModel])
    func didFetchError(error: Error)
}


final class QuestionViewModel: Model {
    
    weak var output: QuestionViewModelOutput!
    private(set) var models: [QustionModel] = []
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
            .init(image: "busket_icon", name: "Как купить"),
            .init(image: "duble_back_icon", name: "Возврат"),
            .init(image: "recipient_icon", name: "Рецепты"),
            .init(image: "paymet_info_icon", name: "Оплата и бонусы"),
            .init(image: "delivary_icon", name: "Доставка"),
            .init(image: "write_us_icon", name: "Напишите нам!")
        ]
        self.models = mockData
        output.didLoad(models: models)

    }
    
    func didSelectCell(at indexPath: IndexPath) {        
        if indexPath.row == (self.models.count - 2) {
            raise(event: ProfileEvent.deliveryTutorial)
        }
        
        if indexPath.row == (self.models.count - 1) {
            raise(event: ProfileEvent.connectWithUs)
        }
    }
}
