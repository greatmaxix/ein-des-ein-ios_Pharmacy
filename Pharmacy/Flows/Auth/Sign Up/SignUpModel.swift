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
    func signUp(name: String?, phone: String?, email: String?)
}

final class SignUpModel: Model {
    
    private func makeSignUpRequest(name: String, phone: String, email: String?) {
        
    }
}

// MARK: - SignUpInput

extension SignUpModel: SignUpInput {
    
    func signUp(name: String?, phone: String?, email: String?) {
        
        if let name: String = name, let phone: String = phone {
            makeSignUpRequest(name: name, phone: phone, email: email)
        }
    }
}
