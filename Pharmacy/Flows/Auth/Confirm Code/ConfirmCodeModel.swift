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
    func sendCode()
    func resendCode()
    
    var phoneNumber: String { get }
}

protocol ConfirmCodeOutput: class {
    func setCode(code: String)
    func unblockResendButton()
    func failedToConfirmCode(message: String)
    var confirmCode: String { get }
}

final class ConfirmCodeModel: Model {
    
    private var phone: String!
    private let provider: DataManager<AuthAPI, LoginResponse> = DataManager<AuthAPI, LoginResponse>()
    private let resendProvider = MoyaProvider<AuthAPI>()

    weak var output: ConfirmCodeOutput!
    
    init(parent: EventNode, phone: String) {
        super.init(parent: parent)
        self.phone = phone
    }
    
    // TODO: Add sms code
    
    private func login() {
        
        self.provider.load(target: .login(phone: phone, code: output.confirmCode)) { [weak self] (result) in
            
            switch result {
            case .success(let response):
                
                let token: String = response.token
                self?.startMainFlow()
            case .failure(let error):
                self?.output.unblockResendButton()
                self?.output.failedToConfirmCode(message: "Failed to verify code.")
                print(error.localizedDescription)
            }
        }
    }
    
    private func resendConfirmCode() {
        
        resendProvider.request(.requestCodeFor(phone: phoneNumber)) { [weak self] (result: Result<Moya.Response, MoyaError>) in
            switch result {
            case .success(let response):
                if 200..<300 ~= response.statusCode {
                } else {
                    self?.output.failedToConfirmCode(message: "Failed to resend code.")
                }
            case .failure(let error):
                self?.output.failedToConfirmCode(message: "Failed to resend code.")
                print(error.localizedDescription)
            }
            self?.output.unblockResendButton()
        }
    }
    
    private func startMainFlow() {
        
        if let appNav = (UIApplication.shared.delegate as? AppDelegate)?.appNavigationCoordinator {
            
            appNav.startMainFlow()
        }
    }
}

// MARK: - ConfirmCodeInput

extension ConfirmCodeModel: ConfirmCodeInput {
    
    func resendCode() {
        resendConfirmCode()
    }
        
    var phoneNumber: String {
        get {
            return phone
        }
    }
    
    func sendCode() {
        login()
    }
}
