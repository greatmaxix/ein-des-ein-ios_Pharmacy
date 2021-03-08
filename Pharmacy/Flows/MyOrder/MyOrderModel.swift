//
//  MyOrderModel.swift
//  Pharmacy
//
//  Created by Anna Yatsun on 01.03.2021.
//  Copyright © 2021 pharmacy. All rights reserved.
//

import Foundation


protocol MyOrderModelInput: class {
    func load()
    func didSelectCell(at indexPath: IndexPath)
}

protocol MyOrderModelOutput: class {
    func didLoad(models: [TypeOfAnalysis])
    func didFetchError(error: Error)
}

final class MyOrderModel: Model {
    
    weak var output: MyOrderModelOutput!
    private let analisisListProvider = DataManager<AnalisisListAPI, AnalisisAndDiagnosResponse>()
    private var typesOfAnalysis: [TypeOfAnalysis] = []
}


extension MyOrderModel: MyOrderViewControllerOutput {
    
    func load() {
        let mockData: [TypeOfAnalysis] = [
            .init(analisName: "Лабараторные исследования"),
            .init(analisName: "Отделение ЭКО"),
            .init(analisName: "Массаж")
        ]
        //self.output.didLoad(models: mockData)
        self.typesOfAnalysis = mockData
        
        self.analisisListProvider.load(target: .getAnalis) { [weak self] result in
            switch result {
            case let .success(response):
                self?.typesOfAnalysis = response.item
                self?.output.didLoad(models: response.item)
            case let .failure(error):
                self?.output.didFetchError(error: error)
            }
        }
    }
    
    func didSelectCell(at indexPath: IndexPath) {
//        let model = self.typesOfAnalysis[indexPath.row]
        self.raise(event: ProfileEvent.openCloseOrder)
    }
}
