//
//  OnboardingSlideCollectionViewCell.swift
//  Pharmacy
//
//  Created by Sapa Denys on 02.09.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

enum SlideOption {
    case onNext
    case toCategories
    case toAuth
}

struct SlideInfo {
    let image: UIImage
    let title: String
    let description: String
    var slideOption: SlideOption
    var skipTitle: String
    var applyButtonTitle: String
    
    init(image: UIImage, title: String, description: String, skipTitle: String? = nil, applyTitle: String? = nil, option: SlideOption = .onNext) {
        self.image = image
        self.title = title
        self.description = description
        self.slideOption = option
        self.skipTitle = skipTitle ?? R.string.localize.onboardingButtonSkip()
        self.applyButtonTitle = applyTitle ?? R.string.localize.onboardingButtonNext()
    }
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
