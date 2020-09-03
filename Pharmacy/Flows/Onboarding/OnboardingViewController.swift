//
//  OnboardingViewController.swift
//  Pharmacy
//
//  Created by Sapa Denys on 02.09.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

protocol OnboardingModelOutput: AnyObject {
    func routeToSlide(at index: Int)
}

final class OnboardingViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var nextButton: UIButton!
    @IBOutlet private weak var skipButton: UIButton!

    // MARK: - Properties
    var model: OnboardingModel!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupContainerView()
        setupContainerViewEdgeGesture()
        setupButtons()
    }
}

// MARK: - Actions
extension OnboardingViewController {

    @IBAction private func onNextButtonTouchUp(_ sender: UIButton) {
        model.onNextAction()
    }

    @IBAction private func onSkipButtonTouchUp(_ sender: UIButton) {
        model.onSkipButtonAction()
    }

    @IBAction private func onRightEdgeGesture(_ sender: UIGestureRecognizer) {
        guard sender.state == .ended else {
            return
        }

        model.onNextAction()
    }
}

// MARK: - OnboardingModelOutput
extension OnboardingViewController: OnboardingModelOutput {

    func routeToSlide(at index: Int) {
        selectSlide(at: index)
    }
}

// MARK: - Private methods
extension OnboardingViewController {

    private func setupContainerView() {
        collectionView.registerReusableCell(cellType: OnboardingSlideCollectionViewCell.self)
    }

    private func setupContainerViewEdgeGesture() {
        let rightGesture = UIScreenEdgePanGestureRecognizer(target: self,
                                                            action: #selector(onRightEdgeGesture))
        rightGesture.edges = .right
        containerView.addGestureRecognizer(rightGesture)
    }

    private func setupButtons() {
        nextButton.layer.cornerRadius = nextButton.frame.height / 2
        nextButton.setTitle(R.string.localize.onboardingButtonNext(),
                            for: .normal)
        skipButton.setTitle(R.string.localize.onboardingButtonSkip(),
                            for: .normal)
    }

    private func selectSlide(at index: Int, animated: Bool = true) {
        guard index < collectionView.numberOfItems(inSection: 0) else {
            return
        }

        let indexPath = IndexPath(item: index, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: animated)
    }
}

// MARK: - UICollectionViewDataSource
extension OnboardingViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return model.slideInfos.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: OnboardingSlideCollectionViewCell = collectionView.dequeueReusableCell(at: indexPath)
        cell.setupContent(with: model.slideInfos[indexPath.row])
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension OnboardingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
}
