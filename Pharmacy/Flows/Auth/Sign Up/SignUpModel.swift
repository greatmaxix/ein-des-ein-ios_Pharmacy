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
import Alamofire

enum SignUpEvent: Event {
    case receiveCode(phone: String)
}

protocol SignUpOutput: UIBlockerDelegate {
    
    func failedToSignUp(message: String)
}

protocol SignUpInput {
    func signUp(name: String?, phone: String?, email: String?)
}

final class SignUpModel: Model {
    
    private let provider = MoyaProvider<AuthAPI>()
    
    unowned var output: SignUpOutput!
    
    private func makeSignUpRequest(name: String, phone: String, email: String?) {
        
        provider.request(.register(name: name, phone: phone, email: email)) { [weak self] (result: Result<Moya.Response, MoyaError>) in
            
            guard let self: SignUpModel = self else { return }

            switch result {
            case .success(let response):
                if 200..<300 ~= response.statusCode {
                    self.raise(event: SignUpEvent.receiveCode(phone: phone))
                } else {
                    self.output.failedToSignUp(message: "Failed to create account.")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
            self.output.unblockApplyButton()
        }
    }
}

// MARK: - SignUpInput

extension SignUpModel: SignUpInput {
    
    func signUp(name: String?, phone: String?, email: String?) {
        
        if let name: String = name, var phone: String = phone {
            
            phone = phone.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
            makeSignUpRequest(name: name, phone: phone, email: email)
        }
    }
}
