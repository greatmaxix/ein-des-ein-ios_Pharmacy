//
//  ChatEvaluationViewController.swift
//  Pharmacy
//
//  Created by Egor Bozko on 17.11.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

class ChatEvaluationViewController: UIViewController {
    
    enum UIState {
        case normal, comments
    }
    
    @IBOutlet weak var evaluationView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtittleLabel: UILabel!
    @IBOutlet weak var commentsView: UIView!
    @IBOutlet weak var starsView: UIStackView!
    @IBOutlet weak var star1: UIButton!
    @IBOutlet weak var star2: UIButton!
    @IBOutlet weak var star3: UIButton!
    @IBOutlet weak var star4: UIButton!
    @IBOutlet weak var star5: UIButton!
    @IBOutlet weak var tagsCollection: UICollectionView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var nextButton: RoundedButton!
    
    private var buttons: [UIButton] = []
    private var state: UIState = .normal {
        didSet {
            UIView.animate(withDuration: 0.3) {
                switch self.state {
                case .normal:
                    self.commentsView.isHidden = true
                    self.starsView.alpha = 1.0
                case .comments:
                    self.commentsView.isHidden = false
                    self.starsView.alpha = 0.0
                }
            }
        }
    }
    private let modalAppearTransition = ModalPresentingTransitionioning()
    private let modalDissapearTransition = ModalDissmisingTransitionioning()
    var model: ChatEvaluationInput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttons = [star1, star2, star3, star4, star5]
    }
    
    private var starsCount: Int {
        return buttons.filter{$0.isSelected}.count
    }

    @IBAction func nextAction(_ sender: Any) {
        switch state {
        case .normal:
            if starsCount > 2 {
                model.send(ChatEvaluation(evaluatingRating: starsCount, evaluatingComment: nil, evaluatingTags: nil))
            } else {
                state = .comments
            }
        case .comments:
            model.send(ChatEvaluation(evaluatingRating: starsCount, evaluatingComment: textView.text, evaluatingTags: nil))
        }
    }
    
    @IBAction func laterAction(_ sender: Any) {
        model.later()
    }
    
    @IBAction func starAction(_ sender: UIButton) {
        buttons.forEach { $0.isSelected = false }
        var countToSelect = 0
        switch sender {
        case star1: countToSelect = 1
        case star2: countToSelect = 2
        case star3: countToSelect = 3
        case star4: countToSelect = 4
        case star5: countToSelect = 5
        default: break
        }
        for b in buttons[0...countToSelect - 1] {
            b.isSelected = true
        }
        
        nextButton.isEnabled = true
        nextButton.backgroundColor = R.color.welcomeBlue()
    }
    
}

extension ChatEvaluationViewController: ChatEvaluationOutput {
    
}
    
extension ChatEvaluationViewController: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return modalDissapearTransition
    }
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return modalAppearTransition
    }
}

class BlurEffect: UIVisualEffectView {
    init() {
        super.init(effect: UIBlurEffect(style: .regular))
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
