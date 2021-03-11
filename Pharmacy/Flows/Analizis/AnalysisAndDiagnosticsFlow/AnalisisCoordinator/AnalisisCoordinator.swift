//
//  AnalisisCoordinator.swift
//  Pharmacy
//
//  Created by Anna Yatsun on 18.02.2021.
//  Copyright © 2021 pharmacy. All rights reserved.
//

import Foundation
import EventsTree
import CoreLocation
import MapKit

struct AnalisisFlowConfiguration {
    let parent: EventNode
    let dismisAction: () -> Void
}

final class AnalisisCoordinator: EventNode, Coordinator {
    
    var navigation: UINavigationController?
    var dismisAction: () -> Void = { }
    
    func createFlow() -> UIViewController {
        let root = R.storyboard.analysisAndDiagnostics.instantiateInitialViewController()!
        let model = AnalysisAndDiagnosticsModel(parent: self)
        let nav = NavigationController(rootViewController: root)
        navigation = nav
        root.model = model
        model.output = root

        return nav
    }
    
    deinit {
        debugPrint("\(Self.self)")
    }
    
    init(configuration: AnalisisFlowConfiguration) {
        self.dismisAction = configuration.dismisAction
        super.init(parent: configuration.parent)
        addHandler(.onRaise) { [weak self] (event: AnalysisAndDiagnosticsModelEvent) in
            guard let self = self else { return }
            switch event {
            case .openAnalisis:
                self.openAnalizis()
            case let .openLaboratoryList(type):
                self.openLaboratoryList(type: type)
            case let .openLaboratoryDetail(model):
                self.openLaboratoryDetail(model: model)
            case .openAnalisInformation:
                self.openAnalisInformation()
            case .back:
                self.navigation?.popViewController(animated: true)
            case .openClinicFilial:
                self.openClinicFilial()
            case .openClinic:
                self.openClinic()
            case .openFilialList:
                self.openFilialList()
                break
            case .openOrderService:
                self.openOrder()
            case .openPromocod:
                self.openPromocod()
            case .closeAlert:
                break
            case let .showOnMap(model):
                self.showOnMap(model: model)
            case .finishOrder:
                self.openFinishOrder()
            case .dismis:
                self.navigation?.dismiss(animated: true, completion: { [weak self] in
                    self?.navigation = nil
                })
                
                self.dismisAction()
            }
        }
    }
}

fileprivate extension AnalisisCoordinator {
    
    func showOnMap(model: ClinicModel) {
        let controller = R.storyboard.chooseClinicOnMap.instantiateInitialViewController()!
        let model = ChooseClinicOnMapViewModel(parent: self, model: model)
        model.output = controller
        controller.model = model
        navigation?.pushViewController(controller, animated: true)
    }
    
    func openPromocod() {
        let controller = R.storyboard.promocodViewController.instantiateInitialViewController()!
        let model = PromocodModel(parent: self)
        controller.model = model
        model.output = controller
        controller.modalPresentationStyle = .overFullScreen
        controller.modalTransitionStyle = .crossDissolve
        navigation?.topViewController?.present(controller, animated: true)
    }
    
    func openFinishOrder() {
        let controller = R.storyboard.paymendSuccessfullyAlertController.instantiateInitialViewController()!
        controller.modalPresentationStyle = .overFullScreen
        controller.modalTransitionStyle = .crossDissolve
        navigation?.topViewController?.present(controller, animated: true)
    }
    
    func openAnalizis() {
        let controller = R.storyboard.analysisAndDiagnostics.instantiateInitialViewController()!
        let model = AnalysisAndDiagnosticsModel(parent: self)
        controller.model = model
        model.output = controller
        controller.isMainController = false
        navigation?.pushViewController(controller, animated: true)
    }
    
    func openFilialList() {
        let model = ClinicListModel(parent: self)        
        let controller = R.storyboard.chooseClinicViewController.instantiateInitialViewController()!
        controller.clinicModel = model
        self.navigation?.pushViewController(controller, animated: true)
    }
    
    func openClinicFilial() {
        let controller = R.storyboard.deteilClinicInfoController.instantiateInitialViewController()!
        let model = DeteilClinicInfoModel(parent: self)
        controller.model = model
        model.output = controller
        navigation?.pushViewController(controller, animated: true)
    }
    
    func openClinic() {
        let controller = R.storyboard.informationAboutClicController.instantiateInitialViewController()!
        let model = InformationAboutClicModel(parent: self)
        controller.model = model
        model.output = controller
        navigation?.pushViewController(controller, animated: true)
    }
    
    func openLaboratoryList(type: TypeOfAnalysis) {
        let controller = R.storyboard.laboratoryViewController.instantiateInitialViewController()!
        let model = LaboratoryModel(parent: self)
        controller.model = model
        model.output = controller
        navigation?.pushViewController(controller, animated: true)
    }
    
    func openOrder() {
        let controller = R.storyboard.orderServiceViewController.instantiateInitialViewController()!
        let model = OrderServiceViewModel(parent: self)
        controller.model = model
        model.output = controller
        navigation?.pushViewController(controller, animated: true)
    }
    
    func openLaboratoryDetail(model: LaboratoryResearchModel) {
        let controller = R.storyboard.detailLaboratoryController.instantiateInitialViewController()!
        let model = DeteilLaboratoryyModel(parent: self)
        controller.model = model
        model.output = controller
        navigation?.pushViewController(controller, animated: true)
    }
    
    func openAnalisInformation() {
        let controller = R.storyboard.analisInformationViewController.instantiateInitialViewController()!
        let model = AnalisInformationModel(parent: self)
        controller.model = model
        model.output = controller
        navigation?.pushViewController(controller, animated: true)
    }
    
    func openMyOrderVC() {
        let controller = R.storyboard.myOrderViewController.instantiateInitialViewController()!
        let modelVC = MyOrderModel(parent: self)
        controller.model = modelVC
        modelVC.output = controller
        navigation?.pushViewController(controller, animated: true)
    }
}
