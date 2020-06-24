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
    
    func sendConfirmCode()
    
    var phoneNumber: String { get set }
}

protocol ConfirmCodeOutput: class {
    func setCode(code: String)
}

final class ConfirmCodeModel: Model {
    
    private var phone: String!
    private let provider: DataManager<AuthAPI, LoginResponse> = DataManager<AuthAPI, LoginResponse>()
    
    weak var output: ConfirmCodeOutput!
    
    init(parent: EventNode, phone: String) {
        
        super.init(parent: parent)
        self.phone = phone
    }
    
    // TODO: Add sms code
    
    private func login() {
        
        let code: String = ""

        self.provider.load(target: .login(phone: self.phoneNumber, code: code)) { (result) in
            
            switch result {
            case .success(let response):
                 let _: String = response.token
            case .failure(let error):
                print(error.localizedDescription)
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
