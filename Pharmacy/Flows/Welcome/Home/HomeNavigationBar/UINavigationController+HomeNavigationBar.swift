//
//  UINavigationController+HomeNavigationBar.swift
//  Pharmacy
//
//  Created by Anton Bal’ on 09.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

extension UINavigationController {
    static private var coordinatorHelperKey = "UINavigationController.TransitionCoordinatorHelper"
    
    var transitionCoordinatorHelper: HomeTransitionCoordinator? {
        objc_getAssociatedObject(self, &UINavigationController.coordinatorHelperKey) as? HomeTransitionCoordinator
    }
    
    func addCustomTransitioning() {
        var object = objc_getAssociatedObject(self, &UINavigationController.coordinatorHelperKey)
        guard object == nil else { return }
        object = HomeTransitionCoordinator()
        let nonatomic = objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
        objc_setAssociatedObject(self, &UINavigationController.coordinatorHelperKey, object, nonatomic)
        delegate = object as? HomeTransitionCoordinator
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        configCustomNavigationBar()
    }
    
    @objc private func back() {
        popViewController(animated: true)
    }
    
    private func configCustomNavigationBar() {
        if let bar = navigationBar as? HomeNavigationBar {
            addCustomTransitioning()
            bar.backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
            let edgeSwipeGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
            edgeSwipeGestureRecognizer.edges = .left
            view.addGestureRecognizer(edgeSwipeGestureRecognizer)
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
