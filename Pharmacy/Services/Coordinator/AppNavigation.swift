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
        
        addHandler { [weak self] (event: ProfileEvent) in
            switch event {
            case .logout:
                self?.startFlow()
            default:
                break
            }
        }
        addHandler { [weak self] (event: OnboardingEvent) in
            switch event {
            case .close:
                self?.presentMainFlow()
            case .toAuth:
                self?.presentAuthFlow()
            default:
                break
            }
        }
    }

    func startFlow() {
        
//        presentMainFlow()
       // presentAuthFlow()
        presentOnboardingFlow()
    }
    
    func startMainFlow() {
        //presentAuthFlow()
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
    
    private func presentOnboardingFlow() {
        let configuration = OnboardingFlowConfiguration(parent: self)
        let coordinator = OnboardingCoordinator(configuration: configuration)
        presentCoordinatorFlow(coordinator)
    }

    private func presentCoordinatorFlow(_ coordinator: Coordinator) {
        let root = coordinator.createFlow()
        window.rootViewController = root
        window.makeKeyAndVisible()
    }

}
