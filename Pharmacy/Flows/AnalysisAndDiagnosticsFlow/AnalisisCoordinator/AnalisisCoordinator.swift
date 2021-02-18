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
    let navigation: UINavigationController
}

final class AnalisisCoordinator: EventNode, Coordinator {
    let navigation: UINavigationController
    
    func createFlow() -> UIViewController {
        let root = R.storyboard.analysisAndDiagnostics.instantiateInitialViewController()!
        let model = AnalysisAndDiagnosticsModel(parent: self)
        root.model = model
        model.output = root
        
        return root
    }
    
    init(configuration: AnalisisFlowConfiguration) {
        navigation = configuration.navigation
        super.init(parent: configuration.parent)
        addHandler(.onRaise) { [weak self] (event: AnalysisAndDiagnosticsModelEvent) in
            guard let self = self else { return }
            switch event {
            case let .openAnalysis(type):
                self.openAnalisisBy(type: type)
            case let .openLaboratory(model):
                debugPrint(model)
            }
        }
    }
}

fileprivate extension AnalisisCoordinator {
    
    func openAnalisisBy(type: TypeOfAnalysis) {
        let controller = R.storyboard.laboratoryViewController.instantiateInitialViewController()!
        let model = LaboratoryModel(parent: self)
        controller.model = model
        model.output = controller
        navigation.pushViewController(controller, animated: true)
    }
    
    func openMedicineList(product: Product) {
        let viewController = R.storyboard.catalogue.medicineListViewController()!
        let model = MedicineListModel(product: product, parent: self)
        viewController.model = model
        model.output = viewController
        navigation.pushViewController(viewController, animated: true)
    }
}
