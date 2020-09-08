//
//  OnboardingSlideCollectionViewCell.swift
//  Pharmacy
//
//  Created by Sapa Denys on 02.09.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

struct SlideInfo {
    let image: UIImage
    let title: String
    let description: String
    var skipTitle: String = R.string.localize.onboardingButtonSkip()
    var applyButtonTitle: String = R.string.localize.onboardingButtonNext()
}

class OnboardingSlideCollectionViewCell: UICollectionViewCell {

    // MARK: - Outlets
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setupContent(with info: SlideInfo) {
        imageView.image = info.image
        titleLabel.text = info.title
        descriptionLabel.text = info.description
    }
}

extension OnboardingSlideCollectionViewCell: NibReusable {}
