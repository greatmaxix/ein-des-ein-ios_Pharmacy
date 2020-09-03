//
//  ConfirmCodeModel.swift
//  Pharmacy
//
//  Created by CGI-Kite on 23.06.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import EventsTree
import Moya

protocol ConfirmCodeInput {
    func sendCode(code: String)
    func resendCode()
    func close()
    var phoneNumber: String { get }
}

enum ConfirmCodeEvent: Event {
    case openMainScreen
    case close
}

protocol ConfirmCodeOutput: class {
    func unblockResendButton()
    func failedToConfirmCode(message: String)
}

final class ConfirmCodeModel: Model {
    
    private var phone: String!
    private let provider: DataManager<AuthAPI, LoginResponse> = DataManager<AuthAPI, LoginResponse>()
    weak var output: ConfirmCodeOutput!
    
    init(parent: EventNode, phone: String) {
        super.init(parent: parent)
        self.phone = phone
    }
    
    private func sendCodeAgain() {
        provider.create(target: AuthAPI.requestCodeFor(phone: phone)) { [weak self] result in
            
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if !response {
                    self.output.failedToConfirmCode(message: "Failed to resend code.")
                }
            case .failure:
                self.output.failedToConfirmCode(message: "Failed to resend code.")
            }
            self.output.unblockResendButton()
        }
    }
    
    private func login(code: String) {
        self.provider.load(target: .login(phone: phone, code: code)) { [weak self] (result) in
             
             guard let self: ConfirmCodeModel = self else { return }
             switch result {
             case .success(let response):
                try? UserSession.shared.save(user: response.user, token: response.token)
                self.raise(event: ConfirmCodeEvent.openMainScreen)
             case .failure(let error):
                print(error)
                self.loginFail()
             }
        }
    }
    
    private func loginFail() {
        output.unblockResendButton()
        output.failedToConfirmCode(message: R.string.localize.confirmConfirm_fail())
    }
}

// MARK: - ConfirmCodeInput

extension ConfirmCodeModel: ConfirmCodeInput {
    
    func resendCode() {
        sendCodeAgain()
    }
        
    var phoneNumber: String {
        return phone
    }
    
    func sendCode(code: String) {
        
        login(code: code)
    }
    
    func close() {
        raise(event: ConfirmCodeEvent.close)
    }
}
