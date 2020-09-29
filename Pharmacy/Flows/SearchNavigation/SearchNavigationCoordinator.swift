//
//  SearchNavigationCoordinator.swift
//  Pharmacy
//
//  Created by Anton Bal’ on 19.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import EventsTree

final class SearchNavigationCoordinator: EventNode, NavigationCoordinator {
    lazy private(set) var navigation: UINavigationController = {
        let vc = SearchNavigationController()
        vc.model = SearchNavigationModel(parent: self)
        return vc
    }()
    
    private var model: Model? {
        guard let navigation = navigation as? SearchNavigationController else { return nil }
        return navigation.model as? Model
    }
    
    init(configuration: SearchFlowConfiguration) {
        super.init(parent: configuration.parent)
        
        configuration.parent.addHandler(.onPropagate) {[weak self] (event: SearchNavigationModelEvent) in
            switch event {
            case .openScan:
                self?.openScan()
            case .openList:
                self?.openList()
            }
        }
    }
}

extension SearchNavigationCoordinator {
    fileprivate func openList() {
        guard model?.isActive == true else { return }
        
        let viewController = R.storyboard.catalogue.medicineListViewController()!
        let model = MedicineListModel(parent: self)
        viewController.model = model
        model.output = viewController
        navigation.pushViewController(viewController, animated: true)
    }
    
    fileprivate func openScan() {
        guard model?.isActive == true else { return }
        let vc = ScanCoordinator(configuration: .init(parent: self)).createFlow()
        navigation.pushViewController(vc, animated: true)
    }
}
