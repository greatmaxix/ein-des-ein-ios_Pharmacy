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
import Alamofire

enum SignInEvent: Event {
    case signIn(phone: String)
    case signUp
    case back
}

protocol SignInInput {
    func signIn(phone: String)
    func signUp()
    func openProfile()
    func startMainFlowWithOutRegistration()
    func back()
}

protocol SignInOutput: UIBlockerDelegate {
    
    func failedToLogin(message: String)
}

final class SignInModel: Model {
    
    unowned var output: SignInOutput!
    private let provider = MoyaProvider<AuthAPI>()
    
    private func makeSignInRequest(phone: String) {
        
        let cleanNumber: String = phone.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()

        provider.request(.requestCodeFor(phone: cleanNumber)) { [weak self] (result: Result<Moya.Response, MoyaError>) in
            
            guard let self = self else {return}
            switch result {
            case .success(let response):
                //swiftlint:disable all
                if 200..<300 ~= response.statusCode {
                    self.raise(event: SignInEvent.signIn(phone: cleanNumber))
                } else {
                    self.output.failedToLogin(message: "Failed to login.")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
            self.output.unblockApplyButton()
        }
    }
}

extension SignInModel: SignInInput {
    
    func startMainFlowWithOutRegistration() {
        raise(event: SuccessfulSignUpEvent.openMainScreen)
    }
    
    func signIn(phone: String) {
        makeSignInRequest(phone: phone)
    }
    
    func back(){
        raise(event: SignInEvent.back)
    }
    
    func signUp() {
        let event: SignInEvent = SignInEvent.signUp
        raise(event: event)
    }
    
    func openProfile() {
        let event = ConfirmCodeEvent.openMainScreen
        raise(event: event)
    }

}
