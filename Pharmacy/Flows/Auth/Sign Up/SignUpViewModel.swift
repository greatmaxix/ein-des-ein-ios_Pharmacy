//
//  SignUpViewModel.swift
//  Pharmacy
//
//  Created by CGI-Kite on 22.06.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import EventsTree

enum SignUp: Event {
    
}

protocol SignUpInput {
    func signUp(name: String, phone: String, email: String?)
}

final class SignUpViewModel: Model {
    
    private func makeSignUpRequest(name: String, phone: String, email: String?) {
        
    }
}

// MARK: - SignUpInput

extension SignUpViewModel: SignUpInput {
    
    func signUp(name: String, phone: String, email: String?) {
        
        makeSignUpRequest(name: name, phone: phone, email: email)
    }
}
