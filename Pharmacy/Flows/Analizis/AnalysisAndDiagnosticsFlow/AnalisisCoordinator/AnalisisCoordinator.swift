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
    var navigation: UINavigationController?
}

final class AnalisisCoordinator: EventNode, Coordinator {
    var navigation: UINavigationController?
    
    func createFlow() -> UIViewController {
        let root = R.storyboard.analysisAndDiagnostics.instantiateInitialViewController()!
        let model = AnalysisAndDiagnosticsModel(parent: self)
        root.model = model
        model.output = root

        return root
    }
    
    init(configuration: AnalisisFlowConfiguration) {
        self.navigation = configuration.navigation
        super.init(parent: configuration.parent)
        addHandler(.onRaise) { [weak self] (event: AnalysisAndDiagnosticsModelEvent) in
            guard let self = self else { return }
            switch event {
            case . openAnalisis:
                _ = self.createFlow()
            case let .openLaboratoryList(type):
                self.openLaboratoryList(type: type)
            case let .openLaboratoryDetail(model):
                self.openLaboratoryDetail(model: model)
            case .openAnalisInformation:
                self.openAnalisInformation()
            case .back:
                self.navigation?.popViewController(animated: false)
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
                let controller = R.storyboard.promocodViewController.instantiateInitialViewController()!
                let model = PromocodModel(parent: self)
                controller.model = model
                model.output = controller
                
                controller.modalPresentationStyle = .overFullScreen
                self.navigation?.topViewController?.present(controller, animated: false)

            case .closeAlert:
                print("event ")
            case .finishOrder:
                let controller = R.storyboard.paymendSuccessfullyAlertController.instantiateInitialViewController()!
                controller.modalPresentationStyle = .overFullScreen
//                let model = (parent: self)
//                controller.model = model
//                model.output = controller
//
//                controller.modalPresentationStyle = .overFullScreen
                self.navigation?.topViewController?.present(controller, animated: true)
            }
        }
    }
}

fileprivate extension AnalisisCoordinator {
    
    func openFilialList() {
        let controller = R.storyboard.chooseClinicViewController.instantiateInitialViewController()!
        self.navigation?.pushViewController(controller, animated: false)
    }
    
    func openClinicFilial() {
        let controller = R.storyboard.deteilClinicInfoController.instantiateInitialViewController()!
        let model = DeteilClinicInfoModel(parent: self)
        controller.model = model
        model.output = controller
        self.navigation?.pushViewController(controller, animated: false)
    }
    
    func openClinic() {
        let controller = R.storyboard.informationAboutClicController.instantiateInitialViewController()!
        let model = InformationAboutClicModel(parent: self)
        controller.model = model
        model.output = controller
        self.navigation?.pushViewController(controller, animated: false)
    }
    
    func openLaboratoryList(type: TypeOfAnalysis) {
        let controller = R.storyboard.laboratoryViewController.instantiateInitialViewController()!
        let model = LaboratoryModel(parent: self)
        controller.model = model
        model.output = controller
        navigation?.pushViewController(controller, animated: false)
    }
    
    func openOrder() {
        let controller = R.storyboard.orderServiceViewController.instantiateInitialViewController()!
        let model = OrderServiceViewModel(parent: self)
        controller.model = model
        model.output = controller
        navigation?.pushViewController(controller, animated: false)
    }
    
    func openLaboratoryDetail(model: LaboratoryResearchModel) {
        let controller = R.storyboard.detailLaboratoryController.instantiateInitialViewController()!
        let model = DeteilLaboratoryyModel(parent: self)
        controller.model = model
        model.output = controller
        navigation?.pushViewController(controller, animated: false)
    }
    
    func openAnalisInformation() {
        let controller = R.storyboard.analisInformationViewController.instantiateInitialViewController()!
        let model = AnalisInformationModel(parent: self)
        controller.model = model
        model.output = controller
        navigation?.pushViewController(controller, animated: false)
    }
    
    func openMyOrderVC() {
        let controller = R.storyboard.myOrderViewController.instantiateInitialViewController()!
        let modelVC = MyOrderModel(parent: self)
        controller.model = modelVC
        modelVC.output = controller
        navigation?.pushViewController(controller, animated: false)
    }
}
