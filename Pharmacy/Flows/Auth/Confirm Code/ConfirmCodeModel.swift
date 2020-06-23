//
//  ConfirmCodeModel.swift
//  Pharmacy
//
//  Created by CGI-Kite on 23.06.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import Moya

protocol ConfirmCodeInput {
    
    func sendConfirmCode(code: String, phone: String)
}

protocol ConfirmCodeOutput: class {
    func setCode(code: String)
}

final class ConfirmCodeModel {
    
    var code: String? {
        willSet {
            if let value: String = newValue {
                output.setCode(code: value)
            }
        }
    }
    
    var phone: String?
    
    private let provider: DataManager<AuthAPI, LoginResponse> = DataManager<AuthAPI, LoginResponse>()
    
    weak var output: ConfirmCodeOutput!
    
    init(code: String) {
        self.code = code
    }
    
    private func login() {
        
        if let phone: String = phone, let code: String = code {
            
            provider.load(target: .login(phone: phone, code: code)) { [weak self] (result) in
                switch result {
                case .success(let response):
                     let token: String = response.token
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}

// MARK: - ConfirmCodeInput

extension ConfirmCodeModel: ConfirmCodeInput {
    
    func sendConfirmCode(code: String, phone: String) {
        //
    }
}
