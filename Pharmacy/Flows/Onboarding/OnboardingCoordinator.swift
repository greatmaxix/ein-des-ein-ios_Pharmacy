//
//  OnboardingCoordinator.swift
//  Pharmacy
//
//  Created by Sapa Denys on 02.09.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit
import EventsTree

struct OnboardingFlowConfiguration {

    let parent: EventNode
}

class OnboardingCoordinator: EventNode, Coordinator {

    // MARK: - Properties
    
    private weak var root: UINavigationController!

    init(configuration: OnboardingFlowConfiguration) {
        super.init(parent: configuration.parent)

        addHandler { [weak self] (event: OnboardingEvent) in
            switch event {
            case .close:
                self?.popController()
            case .closeRegion, .regionSelected:
                self?.popController(animated: true)
            case .openRegions:
                self?.openRegions()
            }
        }
    }

    // MARK: - Public methods
    
    func createFlow() -> UIViewController {
        let onboardingViewController: OnboardingViewController = R.storyboard.onboarding.onboardingContainerViewController()!
        let model = OnboardingModel(parent: self)

        onboardingViewController.model = model
        model.output = onboardingViewController

        let navigationViewController: UINavigationController = .init(navigationBarClass: SimpleNavigationBar.self,
                                                                     toolbarClass: nil)
        navigationViewController.setViewControllers([onboardingViewController], animated: false)
        navigationViewController.isToolbarHidden = true
        navigationViewController.isNavigationBarHidden = true

        root = navigationViewController

        return root
    }
}

// MARK: - Private methods
extension OnboardingCoordinator {
    
    private func popController(animated: Bool = true) {
        root.isNavigationBarHidden = true
        root.popViewController(animated: animated)
    }
    
    private func openRegions() {
        guard let viewController = R.storyboard.chooseLocationViewController.chooseLocationViewController() else {return}
        let model = ChooseLocationViewModel.init(parent: self, configuretion: .onboarding)
        model.output = viewController
        viewController.model = model
        root.pushViewController(viewController, animated: true)
    }
}
