//
//  SignUpViewModel.swift
//  Pharmacy
//
//  Created by CGI-Kite on 22.06.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import EventsTree
import Moya

enum SignUpEvent: Event {
    case receiveCode(code: String)
}

protocol SignUpInput {
    func signUp(name: String?, phone: String?, email: String?)
    func receiveCode(code: String)
}

final class SignUpModel: Model {
    
    private func makeSignUpRequest(name: String, phone: String, email: String?) {
        let provider = MoyaProvider<AuthAPI>()
        
        DispatchQueue.global(qos: .background).async {
            provider.request(.register(name: name, phone: phone, email: email!), completion: { [weak self] (result: Result<Moya.Response, MoyaError>) in
                
                DispatchQueue.main.async {
                    
                    switch result {
                    case .success(let response):
                        self?.raise(event: SignUpEvent.receiveCode(code: "111111"))
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            })
        }
    }
}

// MARK: - SignUpInput

extension SignUpModel: SignUpInput {
    
    func receiveCode(code: String) {
        //
    }
    
    func signUp(name: String?, phone: String?, email: String?) {
        
        if let name: String = name, var phone: String = phone {
            
            phone = phone.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
            makeSignUpRequest(name: name, phone: phone, email: email)
        }
    }
}
