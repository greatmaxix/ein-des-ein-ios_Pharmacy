//
//  SignInViewModel.swift
//  Pharmacy
//
//  Created by CGI-Kite on 22.06.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import EventsTree

enum SignInEvent: Event {
    case signIn(phone: String)
    case signUp
}

protocol SignInInput {
    func signIn(phone: String)
    func signUp()
}

protocol SignInOutput {
    
}

final class SignInViewModel: Model {
    
    private func makeSignInRequest(phone: String) {
        
    }
}

extension SignInViewModel: SignInInput {
    
    func signIn(phone: String) {
        makeSignInRequest(phone: phone)
    }
    
    func signUp() {
        let event: SignInEvent = SignInEvent.signUp
        raise(event: event)
    }
}
