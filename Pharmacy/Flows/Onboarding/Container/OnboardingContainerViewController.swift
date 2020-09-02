//
//  OnboardingContainerViewController.swift
//  Pharmacy
//
//  Created by Sapa Denys on 02.09.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

class OnboardingContainerViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var nextButton: UIButton!
    @IBOutlet private weak var skipButton: UIButton!

    // MARK: - Properties
    private var pageViewController: UIPageViewController!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupContainerView()
    }
}

// MARK: - Private methods
extension OnboardingContainerViewController {

    private func setupContainerView() {
        let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        pageViewController.dataSource = self
        guard let pageView = pageViewController.view else {
            return
        }

        view.addSubview(pageView)
        pageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([pageView.topAnchor.constraint(equalTo: view.topAnchor),
                                     pageView.leftAnchor.constraint(equalTo: view.leftAnchor),
                                     pageView.rightAnchor.constraint(equalTo: view.rightAnchor),
                                     pageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])

        self.pageViewController = pageViewController
        addChild(pageViewController)
        pageViewController.willMove(toParent: self)
        
        setFirstViewController()
    }

    private func setFirstViewController() {

    }
}

// MARK: - Actions
extension OnboardingContainerViewController {

    @IBAction private func onNextButtonTouchUp(_ sender: UIButton) {

    }

    @IBAction private func onSkipButtonTouchUp(_ sender: UIButton) {

    }
}

// MARK: - UIPageViewControllerDataSource
extension OnboardingContainerViewController: UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return nil
    }
}
