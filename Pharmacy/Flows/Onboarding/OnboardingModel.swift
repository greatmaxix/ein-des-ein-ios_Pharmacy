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
    case regionSelected(_ index: Int?)
}

protocol OnboardingModelInput {
    
    var startSlide: SlideInfo? { get }
    func onSkipButtonAction()
    func onNextAction()
}

class OnboardingModel: Model {

    // MARK: - Properties
    weak var output: OnboardingModelOutput!
    
    override init(parent: EventNode?) {
        super.init(parent: parent)
        
        addHandler { [weak self] (event: OnboardingEvent) in
            
            guard let self = self else { return }
            if case OnboardingEvent.regionSelected(let index) = event {
                guard index == nil else {
                    self.currentIndex = 4
                    self.output.routeToSlide(at: index!)
                    return
                }
                
                self.currentIndex += 1
                self.output.routeToSlide(at: self.currentIndex)
            }
        }
    }

    private(set) var slideInfos: [SlideInfo] = {
        [SlideInfo(image: R.image.illustration_onboarding_1()!,
                   title: R.string.localize.onboardingTitle1(),
                   description: R.string.localize.onboardingText1()),
         SlideInfo(image: R.image.illustration_onboarding_2()!,
                   title: R.string.localize.onboardingTitle2(),
                   description: R.string.localize.onboardingText2()),
         SlideInfo(image: R.image.illustration_onboarding_3()!,
                   title: R.string.localize.onboardingTitle3(),
                   description: R.string.localize.onboardingText3()),
         SlideInfo(image: R.image.illustration_location()!,
                   title: R.string.localize.onboardingTitleCity(),
                   description: R.string.localize.onboardingDescription(), option: .toCategories),
         SlideInfo(image: R.image.illustration_purchase()!,
                   title: R.string.localize.onboardingTitlePurchase(),
                   description: R.string.localize.onboardingDescriptionPurchase(),
                   skipTitle: R.string.localize.onboardingButtonSkipPurchase(),
                   applyTitle: R.string.localize.onboardingButtonNextPurchase(),
                   option: .toAuth)
         ]
    }()

    private var currentIndex: Int = 0
}

// MARK: - Private methods
extension OnboardingModel {

    private func closeFlow() {
        UserDefaultsAccessor.write(value: true, for: \.isPassedOnboarding)
        
        switch currentIndex {
        case 3:
            raise(event: OnboardingEvent.close)
        case 4:
            raise(event: OnboardingEvent.close)
        default:
            openRegions()
        }
    }
    
    private func openRegions() {
        raise(event: OnboardingEvent.openRegions)
    }
}

// MARK: - OnboardingModelInput
extension OnboardingModel: OnboardingModelInput {
    
    var startSlide: SlideInfo? {
        slideInfos.first
    }
    
    func onNextAction() {
        switch slideInfos[currentIndex].slideOption {
        case .onNext:
            self.currentIndex += 1
            self.output.routeToSlide(at: self.currentIndex)
        case .toCategories:
            openRegions()
        case .toAuth:
            closeFlow()
        }
    }

    func onSkipButtonAction() {
        closeFlow()
    }
}
