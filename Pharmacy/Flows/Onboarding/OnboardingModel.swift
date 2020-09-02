//
//  OnboardingModel.swift
//  Pharmacy
//
//  Created by Sapa Denys on 02.09.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

protocol OnboardingModelInput {
    func close()
}

class OnboardingModel: Model {

    // MARK: - Properties
    private(set) var slideInfos: [SlideInfo] = {
        [SlideInfo(image: R.image.onboarding()!,
                   title: R.string.localize.onboardingTitle(),
                   description: R.string.localize.onboardingDescription()),
         SlideInfo(image: R.image.onboarding()!,
                   title: R.string.localize.onboardingTitle(),
                   description: R.string.localize.onboardingDescription()),
         SlideInfo(image: R.image.onboarding()!,
                   title: R.string.localize.onboardingTitle(),
                   description: R.string.localize.onboardingDescription())]
    }()
}

// MARK: - OnboardingModelInput
extension OnboardingModel: OnboardingModelInput {

    func close() {

    }
}
