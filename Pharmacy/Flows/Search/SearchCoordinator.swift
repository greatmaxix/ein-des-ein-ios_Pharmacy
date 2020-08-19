//
//  SearchCoordinator.swift
//  Pharmacy
//
//  Created by Anton Bal’ on 07.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import EventsTree

struct SearchFlowConfiguration {
    let parent: EventNode
}

final class SearchCoordinator: EventNode, Coordinator, NaviagationEmbedCoordinable {
    
    lazy private(set) var navigationCoordinator: NavigationCoordinator = SearchNavigationCoordinator(configuration: .init(parent: self))
    
    func createFlow() -> UIViewController {
        let root =  R.storyboard.search.instantiateInitialViewController()!
        let model = SearchModel(parent: self)
        root.model = model
        model.output = root
        navigation.setViewControllers([root], animated: false)
        return navigation
    }
    
    init(configuration: SearchFlowConfiguration) {
        super.init(parent: configuration.parent)
    
        addHandler { [weak self] (event: SearchModelEvent) in
            switch event {
            case .openList:
                self?.openMedicineList()
            }
        }
    }
}

//MARK: - TabBarEmbedCoordinable

extension SearchCoordinator: TabBarEmbedCoordinable {
    var tabItemInfo: TabBarItemInfo {
        return TabBarItemInfo(title: "",
                              icon: R.image.tabbarSearch()?.withRenderingMode(.alwaysOriginal),
                              highlightedIcon: R.image.tabbarSearch()?.withRenderingMode(.alwaysOriginal))
    }
}


extension SearchCoordinator  {
    fileprivate func openMedicineList() {
        let vc = MedicineListCoordinator(configuration: .init(parent: self)).createFlow()
        navigation.pushViewController(vc, animated: true)
    }
}
