//
//  AnalysisAndDiagnosticsModel.swift
//  Pharmacy
//
//  Created by Anna Yatsun on 18.02.2021.
//  Copyright © 2021 pharmacy. All rights reserved.
//

import Foundation
import EventsTree


enum AnalysisAndDiagnosticsModelEvent: Event {
    case openLaboratoryDetail(LaboratoryResearchModel)
    case openLaboratoryList(TypeOfAnalysis)
    case openAnalisInformation
    case openClinic(ClinicModel)
    case openClinicFilial(ClinicModel)
    case openFilialList
    case openAnalisis
    case openOrderService(ClinicModel)
    case openPromocod
    case finishOrder
    case back
    case closeAlert
    case showOnMap(ClinicModel)
    case dismis
}

protocol AnalysisAndDiagnosticsModelInput: class {
    func close()
    func load()
    func didSelectCell(at indexPath: IndexPath)
}

protocol AnalysisAndDiagnosticsModelOutput: class {
    func didLoad(models: [TypeOfAnalysis])
    func didFetchError(error: Error)
}

final class AnalysisAndDiagnosticsModel: Model {
    
    weak var output: AnalysisAndDiagnosticsModelOutput!
    private let analisisListProvider = DataManager<AnalisisListAPI, AnalisisAndDiagnosResponse>()
    private var typesOfAnalysis: [TypeOfAnalysis] = []
}

// MARK: - AnalysisAndDiagnosticsModelOutput

extension AnalysisAndDiagnosticsModel: AnalysisAndDiagnosticsControllerOutput {
    
    func close() {
        raise(event: AnalysisAndDiagnosticsModelEvent.dismis)
    }
    
    func load() {
        let mockData: [TypeOfAnalysis] = [
            .init(analisName: "Исследования мочи"),
            .init(analisName: "Биохимические и ИФА исследования мочи"),
            .init(analisName: "Гематологические исследования"),
            .init(analisName: "Исследования кала"),
            .init(analisName: "Цитологические исследования"),
            .init(analisName: "Исследование биологических жидкостей"),
            .init(analisName: "Трансфузионная иммунология"),
            .init(analisName: "Исследование параметров гемостаза"),
            .init(analisName: "Биохимические исследования"),
            .init(analisName: "Ферменты"),
            .init(analisName: "Липиды"),
            .init(analisName: "Электролиты и неорганические вещества"),
            .init(analisName: "Специфические белки и пептиды"),
            .init(analisName: "Кардиопанель ( количественное определение кардиомаркеров )"),
            .init(analisName: "Аллергопанель ( иммуноблоттинг, 20 аллергенов )"),
            .init(analisName: "Иммуноферментная диагностика ( ИФА )"),
            .init(analisName: "Гормоны и антитела ( ИФА )"),
            .init(analisName: "Антифосфолипидный синдром"),
            .init(analisName: "Иммуноглобулины ( ИФА )"),
            .init(analisName: "Онкомаркеры"),
            .init(analisName: "Инфекции ( ИФА и экспресс-тесты )"),
            .init(analisName: "Гепатиты ( ИФА )"),
            .init(analisName: "Панель вирусного гепатита В ( ВГВ, HBV )"),
            .init(analisName: "Паразитарные инвазии ( гельминты )"),
            .init(analisName: "ПЦР диагностика"),
            .init(analisName: "Гепатиты ( качественно, количественно )"),
            .init(analisName: "Патогистологическая лаборатория"),
            .init(analisName: "Гистологические исследования в урологии"),
            .init(analisName: "Гистологические исследования в гинекологии"),
            .init(analisName: "Гистологические исследования в хирургии"),
            .init(analisName: "Гистологические исследования в травматологии"),
            .init(analisName: "Отделение ЭКО"),
            .init(analisName: "Рентген"),
            .init(analisName: "УЗИ"),
            .init(analisName: "Массаж"),
            .init(analisName: "Урология")
        ]
        self.output.didLoad(models: mockData)
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
        let model = self.typesOfAnalysis[indexPath.row]
        self.raise(event: AnalysisAndDiagnosticsModelEvent.openLaboratoryList(model))
    }
}
