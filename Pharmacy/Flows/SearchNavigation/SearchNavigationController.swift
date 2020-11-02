//
//  SearchNavigationController.swift
//  Pharmacy
//
//  Created by Anton Bal’ on 19.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

protocol SearchNavigationControllerInput: SearchNavigationModelOutput {}
protocol SearchNavigationControllerOutput: SearchNavigationModelInput {}

final class SearchNavigationController: NavigationController {
    init() {
        super.init(navigationBarClass: NavigationBar.self, toolbarClass: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    private let transitionCoordinatorHelper = TransitionCoordinator()
    
    var model: SearchNavigationControllerOutput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configCustomNavigationBar()
        delegate = transitionCoordinatorHelper
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let navigationBar = navigationBar as? NavigationBar {
            viewControllers.forEach { $0.additionalSafeAreaInsets.top = navigationBar.height }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        model.controllerDidBecomeVisible()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        model.controllerDidBecomeHidden()
    }
    
    @objc private func back() {
        popViewController(animated: true)
    }
    
    private func configCustomNavigationBar() {
        if let bar = navigationBar as? NavigationBar {
            bar.searchDelegate = self
            bar.backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
            let edgeSwipeGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
            edgeSwipeGestureRecognizer.edges = .left
            view.addGestureRecognizer(edgeSwipeGestureRecognizer)
            let style = (viewControllers.first as? NavigationBarStyled)?.style ?? .normal
            bar.configUIBy(style: style)
            bar.backButton.isHidden = true
            bar.title = viewControllers.first?.title
            view.layoutIfNeeded()
            hideKeyboardByTap()
        }
    }
    
    @objc private func handleSwipe(_ gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        guard let gestureRecognizerView = gestureRecognizer.view else {
            transitionCoordinatorHelper.interactionController = nil
            return
        }
        
        let percent = gestureRecognizer.translation(in: gestureRecognizerView).x / gestureRecognizerView.bounds.size.width
        
        if gestureRecognizer.state == .began {
            transitionCoordinatorHelper.interactionController = UIPercentDrivenInteractiveTransition()
            popViewController(animated: true)
        } else if gestureRecognizer.state == .changed {
            transitionCoordinatorHelper.interactionController?.update(percent)
        } else if gestureRecognizer.state == .ended {
            if percent > 0.5 && gestureRecognizer.state != .cancelled {
                transitionCoordinatorHelper.interactionController?.finish()
            } else {
                transitionCoordinatorHelper.interactionController?.cancel()
            }
            transitionCoordinatorHelper.interactionController = nil
        }
    }
}

// MARK: - SearchNavigationControllerInput

extension SearchNavigationController: SearchNavigationControllerInput {
    
}

// MARK: - NavigationBarDelegate

extension SearchNavigationController: NavigationBarDelegate {
    func navigationBarDidSelectScan() {
        model.openScan()
    }
    
    func navigationBar(didReturn text: String) {
        model.searchBy(text: text)
    }
}
