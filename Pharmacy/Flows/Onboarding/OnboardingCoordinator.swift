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
                self?.popController(animated: false)
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
        root.popViewController(animated: animated)
    }
    
    private func openRegions() {
        let vc = R.storyboard.onboarding.regionViewController()!
        let model = RegionModel(parent: self)
        model.output = vc
        vc.model = model
        root.pushViewController(vc, animated: true)
    }
}
