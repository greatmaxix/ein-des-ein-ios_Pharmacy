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
    
    func sendConfirmCode()
    
    var phoneNumber: String { get set }
}

protocol ConfirmCodeOutput: class {
    func setCode(code: String)
}

final class ConfirmCodeModel {
    
    private var phone: String
    private let provider: DataManager<AuthAPI, LoginResponse> = DataManager<AuthAPI, LoginResponse>()
    
    weak var output: ConfirmCodeOutput!
    
    init(phone: String) {
        self.phone = phone
    }
    
    // TODO: Add sms code
    
    private func login() {
        
        let code: String = ""
        
        DispatchQueue.global(qos: .utility).async { [weak self] in
            guard let `self` = self else {return}
            
            self.provider.load(target: .login(phone: self.phoneNumber, code: code)) { (result) in
                
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                         let _: String = response.token
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
}

// MARK: - ConfirmCodeInput

extension ConfirmCodeModel: ConfirmCodeInput {
    
    var phoneNumber: String {
        get {
            return phone
        }
        set {
            phone = newValue
        }
    }
    
    func sendConfirmCode() {
        login()
    }
}
