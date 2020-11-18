//
//  ModalPresentingTransitionioning.swift
//  Pharmacy
//
//  Created by Egor Bozko on 18.11.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

class BlurEffect: UIVisualEffectView {
    init() {
        super.init(effect: UIBlurEffect(style: .dark))
        backgroundColor = R.color.welcomeBlue()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ModalPresentingTransitionioning: NSObject, UIViewControllerAnimatedTransitioning {
    
    struct GUI {
        static let blurMaxAlpha: CGFloat = 0.4
        static let blurMinAlpha: CGFloat = 0.0
    }

    let blurView = BlurEffect()
    
    let animator = UIViewPropertyAnimator()
    
    open var isPresentingDrawer: Bool {
        return true
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
       
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let isPresenting = isPresentingDrawer
        
        let drawerSize = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        
        let fromView = transitionContext.viewController(forKey: .from)!.view!
        let toView = transitionContext.viewController(forKey: .to)!.view!
        
        let drawerView = isPresenting ? toView : fromView
        
        let onScreenDrawerFrame = CGRect(origin: .zero, size: drawerSize)
        let offScreenDrawerFrame = CGRect(origin: CGPoint(x: 0, y: onScreenDrawerFrame.height), size: drawerSize)
       
        drawerView.frame = isPresenting ? offScreenDrawerFrame : onScreenDrawerFrame
        var blur: BlurEffect!
        if isPresenting {
            blurView.frame = onScreenDrawerFrame
            blurView.alpha = isPresenting ? GUI.blurMinAlpha : GUI.blurMaxAlpha
            transitionContext.containerView.addSubview(blurView)
            transitionContext.containerView.addSubview(drawerView)
            blur = blurView
        } else {
            blur = transitionContext.containerView.subviews.first(where: {$0 is BlurEffect}) as? BlurEffect
        }

        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            drawerView.frame = isPresenting ? onScreenDrawerFrame: offScreenDrawerFrame
            blur.alpha = isPresenting ? GUI.blurMaxAlpha : GUI.blurMinAlpha
        }, completion: { (success) in
            if !isPresenting && success {
                blur.removeFromSuperview()
                drawerView.removeFromSuperview()
            }
            transitionContext.completeTransition(success)
        })
    }
}

class ModalDissmisingTransitionioning: ModalPresentingTransitionioning {
    override var isPresentingDrawer: Bool {
        return false
    }
}
