//
//  SignInViewModel.swift
//  Pharmacy
//
//  Created by CGI-Kite on 22.06.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import EventsTree
import Moya

enum SignInEvent: Event {
    case signIn(phone: String)
    case signUp
}

protocol SignInInput {
    func signIn(phone: String)
    func signUp()
}

protocol SignInOutput: UIBlockerDelegate {
}

final class SignInModel: Model {
    
    weak var output: SignInOutput!
    private let provider = MoyaProvider<AuthAPI>()
    
    private func makeSignInRequest(phone: String) {
        
        DispatchQueue.global(qos: .utility).async { [weak self] in
            self?.provider.request(.requestCodeFor(phone: phone), callbackQueue: DispatchQueue.main) {  (result: Result<Moya.Response, MoyaError>) in
                switch result {
                case .success(let response):
                    
                    if 200..<300 ~= response.statusCode {
                        self?.raise(event: SignInEvent.signIn(phone: phone))
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
                self?.output.unblockApplyButton()
            }
        }
    }
}

extension SignInModel: SignInInput {
    
    func signIn(phone: String) {
        makeSignInRequest(phone: phone)
    }
    
    func signUp() {
        let event: SignInEvent = SignInEvent.signUp
        raise(event: event)
    }
}
