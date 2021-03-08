//
//  InformationAboutClicModel.swift
//  Pharmacy
//
//  Created by Anna Yatsun on 26.02.2021.
//  Copyright © 2021 pharmacy. All rights reserved.
//

import Foundation



import Foundation
import EventsTree
import CoreLocation

protocol InformationAboutClicModelInput: class {
    func configureTableView(_ table: UITableView?)
    func load()
    func didSelectCell(at indexPath: IndexPath)
}

protocol InformationAboutClicModelOutput: class {
    func didFetchTableHeight(_ height: CGFloat)
    func didFetchError(error: Error)
    func didLoad()
}

final class InformationAboutClicModel: Model {
    
    weak var output: InformationAboutClicModelOutput!
    private let analisisListProvider = DataManager<AnalisisListAPI, AnalisisAndDiagnosResponse>()
    private var typesOfAnalysis: [TypeOfAnalysis] = []
    private var tableAdapter: TableAdapter?
    
    var types: [TypeOfAnalysis] = [
        .init(analisName: "Лабараторные исследования"),
        .init(analisName: "Отделение ЭКО"),
        .init(analisName: "Массаж"),
        .init(analisName: "Лабараторные исследования"),
        .init(analisName: "Отделение ЭКО"),
        .init(analisName: "Массаж")
    ]
    
    var clinics: [ClinicModel] = [
        ClinicModel(clinicName: "Инвитро", adressClinic: "ул Горная 23а, Харьков", imageClinic: "logo_invitro", priceClinic: "568 ₸  ", phoneNumber: "📞️ +7 (098) 000 02 00 • +7 (098) 000 02 00", ordered: false),
        ClinicModel(clinicName: "Инвитро", adressClinic: "ул Горная 23а, Харьков", imageClinic: "logo_seneva", priceClinic: "568 ₸  ", phoneNumber: "📞️ +7 (098) 000 02 00 • +7 (098) 000 02 00", ordered: false),
        ClinicModel(clinicName: "Инвитро", adressClinic: "ул Горная 23а, Харьков", imageClinic: "logo_invitro", priceClinic: "568 ₸  ", phoneNumber: "📞️ +7 (098) 000 02 00 • +7 (098) 000 02 00", ordered: false),
        ClinicModel(clinicName: "Инвитро", adressClinic: "ул Горная 23а, Харьков", imageClinic: "logo_invitro", priceClinic: "568 ₸  ", phoneNumber: "📞️ +7 (098) 000 02 00 • +7 (098) 000 02 00", ordered: false),
        ClinicModel(clinicName: "Инвитро", adressClinic: "ул Горная 23а, Харьков", imageClinic: "logo_seneva", priceClinic: "568 ₸  ", phoneNumber: "📞️ +7 (098) 000 02 00 • +7 (098) 000 02 00", ordered: false),
        ClinicModel(clinicName: "Инвитро", adressClinic: "ул Горная 23а, Харьков", imageClinic: "logo_invitro", priceClinic: "568 ₸  ", phoneNumber: "📞️ +7 (098) 000 02 00 • +7 (098) 000 02 00", ordered: false),
        ClinicModel(clinicName: "Инвитро", adressClinic: "ул Горная 23а, Харьков", imageClinic: "logo_invitro", priceClinic: "568 ₸  ", phoneNumber: "📞️ +7 (098) 000 02 00 • +7 (098) 000 02 00", ordered: false),
        ClinicModel(clinicName: "Инвитро", adressClinic: "ул Горная 23а, Харьков", imageClinic: "logo_seneva", priceClinic: "568 ₸  ", phoneNumber: "📞️ +7 (098) 000 02 00 • +7 (098) 000 02 00", ordered: false),
        ClinicModel(clinicName: "Инвитро", adressClinic: "ул Горная 23а, Харьков", imageClinic: "logo_invitro", priceClinic: "568 ₸  ", phoneNumber: "📞️ +7 (098) 000 02 00 • +7 (098) 000 02 00", ordered: false),
        ClinicModel(clinicName: "Инвитро", adressClinic: "ул Горная 23а, Харьков", imageClinic: "logo_invitro", priceClinic: "568 ₸  ", phoneNumber: "📞️ +7 (098) 000 02 00 • +7 (098) 000 02 00", ordered: false),
        ClinicModel(clinicName: "Инвитро", adressClinic: "ул Горная 23а, Харьков", imageClinic: "logo_seneva", priceClinic: "568 ₸  ", phoneNumber: "📞️ +7 (098) 000 02 00 • +7 (098) 000 02 00", ordered: false),
        ClinicModel(clinicName: "Инвитро", adressClinic: "ул Горная 23а, Харьков", imageClinic: "logo_invitro", priceClinic: "568 ₸  ", phoneNumber: "📞️ +7 (098) 000 02 00 • +7 (098) 000 02 00", ordered: false)
    ]
    
    private func prepareTable() {
        let clinicsCount = clinics.count <= 3 ? clinics.count : 3
        let height = CGFloat((clinicsCount * 124) + (types.count * 69) + 160)
        output.didFetchTableHeight(height)
        
        let typesHeader = R.nib.informationHeaderView(owner: nil)!
        typesHeader.configure(title: "Перечень услуг", action: { [weak self] in
            self?.raise(event: AnalysisAndDiagnosticsModelEvent.openAnalisis)
        })
        let filialsHeader = R.nib.informationHeaderView(owner: nil)!
        filialsHeader.configure(title: "Филиалы (\(clinics.count))", action: { [weak self] in
            self?.raise(event: AnalysisAndDiagnosticsModelEvent.openFilialList)
        })
        
        let modelsClinic = clinics.prefix(upTo: 3).map { $0 }
        
        self.tableAdapter?.sections = [
            Section(cell: TypeOfAnalysisCell.self, models: types, header: .init(view: typesHeader, height: 80)),
            Section(cell: ClinicTableCell.self, models: modelsClinic, header: .init(view: filialsHeader, height: 80))
        ]
        
        self.tableAdapter?.eventHandler = { [weak self] event in
            switch event {
            case let.didSelect(index):
                self?.didSelectCell(at: index)
            default:
                break
            }
        }
        
        output.didLoad()
    }
}

// MARK: - InformationAboutClicModelOutput

extension InformationAboutClicModel: InformationAboutClicControllerOutput {
    
    func load() {
        prepareTable()
        
        self.analisisListProvider.load(target: .getAnalis) { [weak self] result in
            switch result {
            case let .success(response):
                self?.typesOfAnalysis = response.item
                //self?.output.didLoad(models: response.item)
            case let .failure(error):
                self?.output.didFetchError(error: error)
            }
        }
    }
    
    func didSelectCell(at indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            raise(event: AnalysisAndDiagnosticsModelEvent.openLaboratoryList(types[indexPath.row]))
        case 1:
            raise(event: AnalysisAndDiagnosticsModelEvent.openClinicFilial(clinics[indexPath.row]))
        default:
            break
        }
    }
}

extension InformationAboutClicModel {

    func configureTableView(_ tableView: UITableView?) {
        let cellTypes = self.allCellTypes()
        tableView?.rowHeight = UITableView.automaticDimension

        self.tableAdapter = TableAdapter(table: tableView, cells: cellTypes)
        self.tableAdapter?.sections = []
    }

    private func allCellTypes() -> [UITableViewCell.Type] {
        return [
            TypeOfAnalysisCell.self,
            ClinicTableCell.self,
        ]
    }
}
