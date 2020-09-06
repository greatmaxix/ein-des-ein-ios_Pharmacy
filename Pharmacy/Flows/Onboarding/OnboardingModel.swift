//
//  OnboardingModel.swift
//  Pharmacy
//
//  Created by Sapa Denys on 02.09.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import EventsTree

enum OnboardingEvent: Event {
    case close
}

protocol OnboardingModelInput {
    func onSkipButtonAction()
    func onNextAction()
}

class OnboardingModel: Model {

    // MARK: - Properties
    weak var output: OnboardingModelOutput!

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

    private var currentIndex: Int = 0
}

// MARK: - Private methods
extension OnboardingModel {

    private func closeFlow() {
        UserDefaultsAccessor.write(value: true, for: \.isPassedOnboarding)
        raise(event: OnboardingEvent.close)
    }
}

// MARK: - OnboardingModelInput
extension OnboardingModel: OnboardingModelInput {

    func onNextAction() {
        if currentIndex < slideInfos.count - 1 {
            currentIndex += 1
            output.routeToSlide(at: currentIndex)
        } else {
            closeFlow()
        }
    }

    func onSkipButtonAction() {
        closeFlow()
    }
}
