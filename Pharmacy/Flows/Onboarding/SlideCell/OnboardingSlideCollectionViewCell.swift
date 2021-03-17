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
    var skipTitle: String = R.string.localize.onboardingButtonSkip.localized()
    var applyButtonTitle: String = R.string.localize.onboardingButtonNext.localized()
    var backgroundColor: UIColor = R.color.textDarkBlue()!
    var fontColor: UIColor = .white
    var alternativeOnboardingConfiguration: Bool = false
    
    init(image: UIImage, title: String, description: String, skipTitle: String? = nil, applyTitle: String? = nil, option: SlideOption = .onNext, nextButtonTitle: String? = nil, alternativeConfiguration: Bool = false) {
        self.image = image
        self.title = title
        self.description = description
        self.slideOption = option
        self.skipTitle = skipTitle ?? R.string.localize.onboardingButtonSkip.localized()
        self.applyButtonTitle = nextButtonTitle ?? R.string.localize.onboardingButtonNext.localized()
        
        switch alternativeConfiguration {
        case true:
            self.alternativeOnboardingConfiguration = true
            self.backgroundColor = .white
            self.fontColor = R.color.textDarkBlue()!
        case false:
            self.alternativeOnboardingConfiguration = false
            self.backgroundColor = R.color.textDarkBlue()!
            self.fontColor = .white
        }
    }
}

class OnboardingSlideCollectionViewCell: UICollectionViewCell {

    // MARK: - Outlets
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.font = R.font.openSansBold(size: 24)
        descriptionLabel.font = R.font.openSansRegular(size: 16)
    }

    func setupContent(with info: SlideInfo) {
        imageView.image = info.image
        titleLabel.text = info.title
        descriptionLabel.text = info.description
        backgroundColor = info.backgroundColor
        titleLabel.textColor = info.fontColor
        descriptionLabel.textColor = info.fontColor
    
        if info.alternativeOnboardingConfiguration {
        
            NSLayoutConstraint.activate([
                imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -52),
                imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 52),
                imageView.topAnchor.constraint(equalTo: topAnchor, constant: 176)
            ])
            imageView.contentMode = .scaleAspectFit
        }
    }
}

extension OnboardingSlideCollectionViewCell: NibReusable {}
