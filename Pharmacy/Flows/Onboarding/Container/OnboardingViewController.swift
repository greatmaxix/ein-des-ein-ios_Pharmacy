//
//  OnboardingViewController.swift
//  Pharmacy
//
//  Created by Sapa Denys on 02.09.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

final class OnboardingViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var nextButton: UIButton!
    @IBOutlet private weak var skipButton: UIButton!

    // MARK: - Properties
    private var currentIndex: UInt = 0

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupContainerView()
    }
}

// MARK: - Actions
extension OnboardingViewController {

    @IBAction private func onNextButtonTouchUp(_ sender: UIButton) {
        routeToNextSlide()
    }

    @IBAction private func onSkipButtonTouchUp(_ sender: UIButton) {

    }

    @IBAction private func onRightEdgeGesture(_ sender: UIGestureRecognizer) {
        guard sender.state == .ended else {
            return
        }

        routeToNextSlide()
    }
}

// MARK: - Private methods
extension OnboardingViewController {

    private func setupContainerView() {

    }

    private func setupContainerViewEdgeGesture() {
        let rightGesture = UIScreenEdgePanGestureRecognizer(target: self,
                                                            action: #selector(onRightEdgeGesture))
        rightGesture.edges = .right
        containerView.addGestureRecognizer(rightGesture)
    }

    private func routeToNextSlide() {
        currentIndex += 1
        selectSlide(at: currentIndex)
    }

    private func selectSlide(at index: UInt, animated: Bool = true) {
        guard index < collectionView.numberOfItems(inSection: 0) else {
            return
        }

        let indexPath = IndexPath(item: Int(index), section: 0)
        collectionView.layoutIfNeeded()
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: animated)
    }
}

// MARK: - UICollectionViewDataSource
extension OnboardingViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = UICollectionViewCell()
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension OnboardingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
}
