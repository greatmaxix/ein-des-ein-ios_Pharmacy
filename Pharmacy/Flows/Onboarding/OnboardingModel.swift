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
    case openRegions
    case closeRegion
    case selectRegion
    case toAuth
}

protocol OnboardingModelInput {
    func onSkipButtonAction()
    func onNextAction()
}

class OnboardingModel: Model {

    // MARK: - Properties
    weak var output: OnboardingModelOutput!
    
    override init(parent: EventNode?) {
        super.init(parent: parent)
        
        addHandler { [weak self] (event: OnboardingEvent) in
            if event == .selectRegion, let self = self {
                
                self.currentIndex += 1
                self.output.routeToSlide(at: self.currentIndex)
            }
        }
    }

    private(set) var slideInfos: [SlideInfo] = {
        var result = [SlideInfo(image: R.image.onboarding()!,
                   title: R.string.localize.onboardingTitle(),
                   description: R.string.localize.onboardingDescription()),
         SlideInfo(image: R.image.onboarding()!,
                   title: R.string.localize.onboardingTitle(),
                   description: R.string.localize.onboardingDescription()),
         SlideInfo(image: R.image.onboarding()!,
                   title: R.string.localize.onboardingTitle(),
                   description: R.string.localize.onboardingDescription()),
         SlideInfo(image: R.image.onboarding()!,
                   title: R.string.localize.onboardingTitleCity(),
                   description: R.string.localize.onboardingDescription())
         ]
        var lastSlide = SlideInfo(image: R.image.onboarding()!,
                                  title: R.string.localize.onboardingTitlePurchase(),
                                  description: R.string.localize.onboardingDescriptionPurchase())
        lastSlide.skipTitle = R.string.localize.onboardingButtonSkipPurchase()
        lastSlide.applyButtonTitle = R.string.localize.onboardingButtonNextPurchase()
        result.append(lastSlide)
        return result
    }()

    private var currentIndex: Int = 0
}

// MARK: - Private methods
extension OnboardingModel {

    private func closeFlow() {
        raise(event: OnboardingEvent.close)
    }
    
    private func openRegions() {
        raise(event: OnboardingEvent.openRegions)
    }
    
    private func openAuth() {
        raise(event: OnboardingEvent.toAuth)
    }
}

// MARK: - OnboardingModelInput
extension OnboardingModel: OnboardingModelInput {
    
    func onNextAction() {
        if currentIndex < 3 {
            currentIndex += 1
            output.routeToSlide(at: currentIndex)
        } else if currentIndex == 3 {
            openRegions()
        } else {
            openAuth()
        }
    }

    func onSkipButtonAction() {
        closeFlow()
    }
}
