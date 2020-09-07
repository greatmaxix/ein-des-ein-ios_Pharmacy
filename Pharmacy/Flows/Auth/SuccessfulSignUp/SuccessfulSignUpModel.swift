//
//  SuccessfulSignUpModel.swift
//  Pharmacy
//
//  Created by Sapa Denys on 07.09.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import EventsTree

enum SuccessfulSignUpEvent: Event {
    case openMainScreen
}

protocol SuccessfulSignUpModelInput {
    func onViewDidApearAction()
}

final class SuccessfulSignUpModel: Model {
    
}

// MARK: - SuccessfulSignUpModelInput
extension SuccessfulSignUpModel: SuccessfulSignUpModelInput {
    
    func onViewDidApearAction() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 20.0) { [weak self] in
            self?.raise(event: SuccessfulSignUpEvent.openMainScreen)
        }
    }
}
