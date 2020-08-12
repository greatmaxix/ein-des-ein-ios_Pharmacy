//
//  AppNavigation.swift
//  Pharmacy
//
//  Created by Mikhail Timoscenko on 16.06.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import UIKit
import EventsTree

final class AppNavigation: EventNode {

    fileprivate unowned let window: UIWindow

    init(window: UIWindow) {
        self.window = window

        super.init(parent: nil)
        
        addHandler { [weak self] (event: ConfirmCodeEvent) in
            if event == .openMainScreen {
                self?.startMainFlow()
            }
        }
    }

    func startFlow() {
        presentMainFlow()
    }
    
    func startMainFlow() {
        presentMainFlow()
    }
}

// MARK: Navigation

extension AppNavigation {

    fileprivate func presentMainFlow() {
        let coordinator: TabBarCoordinator = TabBarCoordinator(parent: self)
        presentCoordinatorFlow(coordinator)
    }

    fileprivate func presentAuthFlow() {
        let configuration = AuthFlowConfiguration(parent: self)
        let coordinator = AuthFlowCoordinator(configuration: configuration)
        presentCoordinatorFlow(coordinator)
    }

    private func presentCoordinatorFlow(_ coordinator: Coordinator) {
        let root = coordinator.createFlow()
        window.rootViewController = root
        window.makeKeyAndVisible()
    }

}
