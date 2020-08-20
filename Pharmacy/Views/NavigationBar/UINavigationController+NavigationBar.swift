//
//  UINavigationController+NavigationBar.swift
//  Pharmacy
//
//  Created by Anton Bal’ on 09.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

extension UINavigationController {
    static private var coordinatorHelperKey = "UINavigationController.TransitionCoordinatorHelper"
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        configCustomNavigationBar()
    }

    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let navigationBar = navigationBar as? NavigationBar {
            viewControllers.forEach { $0.additionalSafeAreaInsets.top = navigationBar.height }
        }
    }
    
    private var transitionCoordinatorHelper: TransitionCoordinator? {
        objc_getAssociatedObject(self, &UINavigationController.coordinatorHelperKey) as? TransitionCoordinator
    }
    
    private func addCustomTransitioning() {
        var object = objc_getAssociatedObject(self, &UINavigationController.coordinatorHelperKey)
        guard object == nil else { return }
        object = TransitionCoordinator()
        let nonatomic = objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
        objc_setAssociatedObject(self, &UINavigationController.coordinatorHelperKey, object, nonatomic)
        delegate = object as? TransitionCoordinator
    }
    
    @objc private func back() {
        popViewController(animated: true)
    }
    
    private func configCustomNavigationBar() {
        if let bar = navigationBar as? NavigationBar {
            addCustomTransitioning()
            bar.backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
            let edgeSwipeGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
            edgeSwipeGestureRecognizer.edges = .left
            view.addGestureRecognizer(edgeSwipeGestureRecognizer)
            guard let styledVC = viewControllers.first as? NavigationBarStyled else { return }
            bar.configUIBy(style: styledVC.style)
            bar.backButton.isHidden = true
            view.layoutIfNeeded()
        }
    }
    
    @objc func handleSwipe(_ gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        guard let gestureRecognizerView = gestureRecognizer.view else {
            transitionCoordinatorHelper?.interactionController = nil
            return
        }
        
        let percent = gestureRecognizer.translation(in: gestureRecognizerView).x / gestureRecognizerView.bounds.size.width
        
        if gestureRecognizer.state == .began {
            transitionCoordinatorHelper?.interactionController = UIPercentDrivenInteractiveTransition()
            popViewController(animated: true)
        } else if gestureRecognizer.state == .changed {
            transitionCoordinatorHelper?.interactionController?.update(percent)
        } else if gestureRecognizer.state == .ended {
            if percent > 0.5 && gestureRecognizer.state != .cancelled {
                transitionCoordinatorHelper?.interactionController?.finish()
            } else {
                transitionCoordinatorHelper?.interactionController?.cancel()
            }
            transitionCoordinatorHelper?.interactionController = nil
        }
    }
}
