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

extension Foundation.Notification.Name {
    static let Login = Foundation.NSNotification.Name(rawValue: "Login")
}

enum AppEvent: Event {
    case presentInDev(_ model: InDevelopmentModel?)
}

final class AppNavigation: EventNode {

    private unowned let window: UIWindow

    init(window: UIWindow) {
        self.window = window

        super.init(parent: nil)
        
        addNotificationObservers()

        addHandler { [weak self] (event: ConfirmCodeEvent) in
            if event == .openMainScreen {
                self?.presentMainFlow()
            }
        }
        
        addHandler { [weak self] (event: SuccessfulSignUpEvent) in
            if event == SuccessfulSignUpEvent.openMainScreen {
                self?.presentMainFlow()
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
                self?.presentAuthFlow()
            case .startMainFlow:
                self?.presentMainFlow()
            default:
                break
            }
        }
    }

    func startFlow() {
        guard UserDefaultsAccessor.value(for: \.isPassedOnboarding) else {
            presentOnboardingFlow()
            return
        }
        
        switch UserSession.shared.authorizationStatus {
        case .authorized:
            presentMainFlow()
        case .notAuthorized:
            presentAuthFlow()
        }
    }
}

// MARK: Navigation

extension AppNavigation {

    private func presentMainFlow() {
        let coordinator: TabBarCoordinator = TabBarCoordinator(parent: self)
        presentCoordinatorFlow(coordinator)
    }

    private func presentAuthFlow() {
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

extension AppNavigation {
    private func addNotificationObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(openLogin),
            name: .Login,
            object: nil
        )
    }
    
    @objc private func openLogin() {
        presentAuthFlow()
    }
}
