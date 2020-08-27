//
//  NavigationTransitionAnimator.swift
//  Pharmacy
//
//  Created by Anton Bal’ on 09.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

final class TransitionCoordinator: NSObject, UINavigationControllerDelegate {

    var interactionController: UIPercentDrivenInteractiveTransition?
    
    internal func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .push:
            return NavigationTransitionAnimator(presenting: true)
        case .pop:
            return NavigationTransitionAnimator(presenting: false)
        default:
            return nil
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionController
    }
}

final class NavigationTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let presenting: Bool
    
    init(presenting: Bool) {
        self.presenting = presenting
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        TimeInterval(UINavigationController.hideShowBarDuration)
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from) else { return }
        guard let toView = transitionContext.view(forKey: .to) else { return }
        guard let toVC = transitionContext.viewController(forKey: .to) else { return }
        guard let fromVC = transitionContext.viewController(forKey: .from) else { return }
        guard let navigationBar = toVC.navigationController?.navigationBar as? NavigationBar else { return }
        
        let toStyle = (toVC as? NavigationBarStyled)?.style ?? .normal
        let fromStyle = (fromVC as? NavigationBarStyled)?.style ?? .normal
        let toAdditionalViews = (toVC as? NavigationBarStyled)?.additionalViews ?? []
        let fromAdditionalViews = (fromVC as? NavigationBarStyled)?.additionalViews ?? []
        
        let duration = transitionDuration(using: transitionContext)
        
        let container = transitionContext.containerView
        
        if presenting {
            container.backgroundColor = fromView.backgroundColor
            container.addSubview(toView)
        } else {
            container.backgroundColor = toView.backgroundColor
            container.insertSubview(toView, belowSubview: fromView)
        }
        
        let toViewFrame = toView.frame
        toView.frame = CGRect(x: presenting ? toView.frame.width : -toView.frame.width / 2,
                              y: toView.frame.origin.y,
                              width: toView.frame.width,
                              height: toView.frame.height)
        
        UIView.transition(with: navigationBar.titleLabel,
                          duration: duration,
                          options: .transitionCrossDissolve,
                          animations: {
                            navigationBar.titleLabel.alpha = 0
                            navigationBar.title = toVC.title
                            navigationBar.titleLabel.alpha = 1
        }, completion: { _ in
            if transitionContext.transitionWasCancelled {
                navigationBar.title = fromVC.title
            }
        })
        
        UIView.animate(withDuration: duration, delay: 0,
                       options: .curveEaseInOut,
                       animations: {
                        fromView.alpha = 0.5
                        toView.alpha = 1
                        
                        navigationBar.configUIBy(style: toStyle)
                        
                        toView.frame = toViewFrame
                        fromView.frame = CGRect(x: self.presenting ? -fromView.frame.width : fromView.frame.width, y: fromView.frame.origin.y, width: fromView.frame.width, height: fromView.frame.height)
        }, completion: { _ in
            
            if transitionContext.transitionWasCancelled {
                navigationBar.hideButtonsBy(style: fromStyle)
                navigationBar.configUIBy(style: fromStyle)
                navigationBar.title = fromVC.title
                navigationBar.fillStackViewWith(additionalViews: fromAdditionalViews)
            } else {
                navigationBar.hideButtonsBy(style: toStyle)
                navigationBar.fillStackViewWith(additionalViews: toAdditionalViews)
            }
            
            container.addSubview(toView)
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
