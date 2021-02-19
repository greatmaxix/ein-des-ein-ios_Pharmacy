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
}

final class AnalisisCoordinator: EventNode, Coordinator {
    var navigation: UINavigationController?
    
    func createFlow() -> UIViewController {
        let root = R.storyboard.analysisAndDiagnostics.instantiateInitialViewController()!
        let model = AnalysisAndDiagnosticsModel(parent: self)
        root.model = model
        model.output = root
        
        let navigationVC: UINavigationController = UINavigationController(navigationBarClass: SimpleWithSearchNavigationBar.self, toolbarClass: nil)
        navigationVC.setViewControllers([root], animated: false)
        navigationVC.isToolbarHidden = true
        navigation = navigationVC
        
        return navigationVC
    }
    
    init(configuration: AnalisisFlowConfiguration) {
        super.init(parent: configuration.parent)
        addHandler(.onRaise) { [weak self] (event: AnalysisAndDiagnosticsModelEvent) in
            guard let self = self else { return }
            switch event {
            case let .openAnalysis(type):
                self.openAnalisisBy(type: type)
            case let .openLaboratory(model):
                debugPrint(model)
            case .backToAnalisis:
                self.navigation?.popViewController(animated: true)
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
        navigation?.pushViewController(controller, animated: true)
    }
    
    func openDeteilLaboratoryList() {
        let viewController = R.storyboard.catalogue.medicineListViewController()!
        navigation?.pushViewController(viewController, animated: true)
    }
}
