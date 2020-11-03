//
//  WelcomeCoordinator.swift
//  Pharmacy
//
//  Created by CGI-Kite on 27.07.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import EventsTree

struct WelcomeFlowConfiguration {
    let parent: EventNode
}

final class WelcomeCoordinator: EventNode, NaviagationEmbedCoordinable {
    
    lazy private(set) var navigationCoordinator: NavigationCoordinator = SearchNavigationCoordinator(configuration: .init(parent: self))
    
    private let storyboard: UIStoryboard = R.storyboard.welcome()

    init(configuration: WelcomeFlowConfiguration) {
      
        super.init(parent: configuration.parent)
        
        addHandler(.onRaise) { [weak self] (event: WelcomeEvent) in
            switch event {
            case .openAnalizes:
                self?.presentAnalizes()
            case .openReceipts:
                self?.presentPrescriptions()
            case .openMap:
                self?.openCommonMap()
            case .openChat:
                self?.openChat()
            default:
                break
            }
        }
        
        addHandler(.onRaise) { [weak self] (event: CatalogueEvent) in
            switch event {
            case .close:
                self?.popController()
            case .openMedicineListFor(let category):
                self?.openMedicineListFor(category: category)
            }
        }
        
        addHandler(.onRaise) {  [weak self] (event: MedicineListModelEvent) in
            switch event {
            case .openProduct(let medicine):
                self?.openProductMedicineFor(medicine: medicine)
            }
        }
    }
    
    func createFlow() -> UIViewController {
        let root = R.storyboard.welcome.instantiateInitialViewController()!
        let model = WelcomeModel(parent: self)
        model.output = root
        root.model = model
        
        navigation.isToolbarHidden = true
        navigation.setViewControllers([root], animated: false)
        return navigation
    }
}

// MARK: - TabBarEmbedCoordinable

extension WelcomeCoordinator: TabBarEmbedCoordinable {
    
    var tabItemInfo: TabBarItemInfo {
        return TabBarItemInfo(title: R.string.localize.tabbarMain(),
                              icon: R.image.tabbarMain(),
                              highlightedIcon: R.image.tabbarMain())
    }
}

fileprivate extension WelcomeCoordinator {
    func popController() {
        navigation.popViewController(animated: true)
    }
    
    func openCategories(category: Category?) {
        let vc = R.storyboard.catalogue.catalogueViewController()!
        let model = CatalogueModel(category: category, parent: self)
        model.output = vc
        vc.model = model
        navigation.pushViewController(vc, animated: true)
    }
    
    func openMedicineListFor(category: Category) {
        let viewController = R.storyboard.catalogue.medicineListViewController()!
        let model = MedicineListModel(parent: self)
        viewController.model = model
        model.output = viewController
        navigation.pushViewController(viewController, animated: true)
    }
    
    func openProductMedicineFor(medicine: Medicine) {
        let vc = ProductCoordinator(configuration: .init(parent: self, navigation: navigation)).createFlowFor(product: medicine)
        navigation.pushViewController(vc, animated: true)
    }

    func presentAnalizes() {
        guard let analizesVC: AnalizesViewController = R.storyboard.profile().instantiateViewController(withIdentifier: "AnalizesViewController") as? AnalizesViewController else {
                   return
        }

        let model = AnalizesModel(parent: self)
        analizesVC.model = model
        navigation.pushViewController(analizesVC, animated: true)
    }

    func presentPrescriptions() {
        guard let prescriptionsVC: PrescriptionsViewController = R.storyboard.profile().instantiateViewController(withIdentifier: "PrescriptionsViewController") as? PrescriptionsViewController else {
                   return
        }

        let model = PrescriptionsModel(parent: self)
        prescriptionsVC.model = model
        navigation.pushViewController(prescriptionsVC, animated: true)
    }
    
    func openCommonMap() {
        let vc = R.storyboard.welcome.commonMapViewController()!
        let model = CommonMapModel(parent: self)
        vc.model = model
        model.output = vc
        navigation.pushViewController(vc, animated: true)
    }
    
    func openChat() {
        guard let vc = ChatCoordinator(parent: self, navigation: navigation).createFlow() as? ChatViewController else { return }
        let model = ChatModel(parent: self)
        vc.model = model
        model.output = vc
        navigation.pushViewController(vc, animated: true)
    }
}
