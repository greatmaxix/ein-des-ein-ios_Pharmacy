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
    @IBOutlet weak var clearCommentsButton: UIButton!
    
    private var tags = ["Медленные ответы", "Хамство", "Некомпетентность", "Не спросили рецепт", "Советовали очень дорогое"]
    
    private var buttons: [UIButton] = []
    private var state: UIState = .normal {
        didSet {
            self.stateDidChanged()
        }
    }
    private let modalAppearTransition = ModalPresentingTransitionioning()
    private let modalDissapearTransition = ModalDissmisingTransitionioning()
    var model: ChatEvaluationInput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        buttons = [star1, star2, star3, star4, star5]
        evaluationView.layer.cornerRadius = 24.0
        evaluationView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        textView.layer.cornerRadius = textView.frame.height / 2.0
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = R.color.mediumGrey()?.cgColor
        textView.textContainerInset = UIEdgeInsets(top: 12.0, left: 16.0, bottom: 12.0, right: 16.0)
        state = .normal
        setupTagsCollection()
    }
    
    func setupTagsCollection() {
        tagsCollection.allowsMultipleSelection = true
        tagsCollection.register(ChatTagCollectionViewCell.nib, forCellWithReuseIdentifier: ChatTagCollectionViewCell.reuseIdentifier)
        tagsCollection.dataSource = self
        if let layout = tagsCollection.collectionViewLayout as? ChatTagsCollectionViewLayout {
            layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            layout.minimumLineSpacing = 14.0
            layout.minimumInteritemSpacing = 16.0
        }
    }
    
    func stateDidChanged() {
        UIView.animate(withDuration: 0.3) {
            switch self.state {
            case .normal:
                self.titleLabel.text = "Как прошла консультация?"
                self.subtittleLabel.text = "Насколько фармацевт был заинтересован в решении Вашего вопроса?"
                self.commentsView.alpha = 0.0
                self.starsView.alpha = 1.0
                self.starsView.isHidden = false
                self.commentsView.isHidden = true
                self.nextButton.setTitle("Далее", for: .normal)
            case .comments:
                self.titleLabel.text = "Жаль слышать это 😔"
                self.subtittleLabel.text = "Уточните пожалуйста, что пошло не так"
                self.commentsView.alpha = 1.0
                self.commentsView.isHidden = false
                self.starsView.isHidden = true
                self.starsView.alpha = 0.0
                self.nextButton.setTitle("Отправить", for: .normal)
            }
        }
    }
    
    private var starsCount: Int {
        return buttons.filter({ b in b.isSelected }).count
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
            let t: [String]? = tagsCollection.indexPathsForSelectedItems?.map({tags[$0.row]})
            model.send(ChatEvaluation(evaluatingRating: starsCount, evaluatingComment: textView.text, evaluatingTags: t))
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
    
    @IBAction func clearComments(_ sender: Any) {
        textView.text = ""
        textViewDidChange(textView)
    }
}

extension ChatEvaluationViewController: ChatEvaluationOutput {}
    
extension ChatEvaluationViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatTagCollectionViewCell.reuseIdentifier, for: indexPath)
        (cell as? ChatTagCollectionViewCell)?.tagTitleLabel.text = tags[indexPath.row]
        return cell
    }
}

extension ChatEvaluationViewController: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return modalDissapearTransition
    }
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return modalAppearTransition
    }
}

extension ChatEvaluationViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let isTextEmpty = textView.text.isEmpty
        placeholderLabel.isHidden = !isTextEmpty
        clearCommentsButton.isHidden = isTextEmpty
    }
}
