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
    
    private var buttons: [UIButton] = []
    private var state: UIState = .normal
    
    var model: ChatEvaluationInput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttons = [star1, star2, star3, star4, star5]
    }
    
    private var starsCount: Int {
        return buttons.filter{$0.isSelected}.count
    }

    @IBAction func nextAction(_ sender: Any) {
        if starsCount > 2 {
            model.send(ChatEvaluation(evaluatingRating: starsCount, evaluatingComment: nil, evaluatingTags: nil))
        } else {
            state = .comments
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
    }
    
}

extension ChatEvaluationViewController: ChatEvaluationOutput {
    
}
