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

    private(set) var slideInfos: [SlideInfo] = {
        [SlideInfo(),
        SlideInfo(),
        SlideInfo()]
    }()
}

// MARK: - OnboardingModelInput
extension OnboardingModel: OnboardingModelInput {

    func close() {

    }
}

extension OnboardingModel {
    
    struct SlideInfo {
        
    }
}
