//
//  CustomIntensityVisualEffectView.swift
//  Pharmacy
//
//  Created by Anton Bal’ on 19.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

@IBDesignable
class CustomIntensityVisualEffectView: UIVisualEffectView {
    
    /// Custom intensity from 0.0 (no effect) to 1.0 (full effect) using linear scale
    @IBInspectable var intensity: CGFloat = 0.2 {
        didSet { setNeedsDisplay() }
    }
    
    // MARK: Private
    private var animator: UIViewPropertyAnimator!
    
    /// Create visual effect view with given effect and its intensity
    ///
    /// - Parameters:
    ///   - effect: visual effect, eg UIBlurEffect(style: .dark)
    ///   - intensity: custom intensity from 0.0 (no effect) to 1.0 (full effect) using linear scale
    init(effect: UIVisualEffect, intensity: CGFloat) {
        super.init(effect: nil)
        animator = UIViewPropertyAnimator(duration: 1, curve: .linear) { [unowned self] in self.effect = effect }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let effect = self.effect
        self.effect = nil
        animator = UIViewPropertyAnimator(duration: 1, curve: .linear) { [unowned self] in self.effect = effect }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        animator.fractionComplete = CGFloat(intensity)
    }
}
