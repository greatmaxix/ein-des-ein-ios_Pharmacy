//
//  AuthCoordinator.swift
//  Pharmacy
//
//  Created by Mikhail Timoscenko on 16.06.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import EventsTree

struct AuthFlowConfiguration {

  let parent: EventNode

}

class AuthFlowCoordinator: EventNode, Coordinator {
    
    private let storyboard = UIStoryboard(name: "Auth", bundle: nil)

    fileprivate weak var root: SignInViewController!

    init(configuration: AuthFlowConfiguration) {
        super.init(parent: configuration.parent)
    
        addHandler { [weak self] (event: SignInEvent) in
            switch event {
            case .signIn(let phone):
                
                self?.presentConfirmSMS(phone: phone)
            case .signUp:
                self?.presentSignUp()
            }
        }
        
        addHandler { [weak self] (event: SignUpEvent) in
            switch event {
            case .receiveCode(let phone):
                self?.presentConfirmSMS(phone: phone)
            }
        }
    }

    func createFlow() -> UIViewController {
        // swiftlint:disable force_cast
        let signInController = storyboard.instantiateViewController(
            withIdentifier: "SignInViewController") as! SignInViewController
        // swiftlint:enable force_cast

        signInController.model = SignInModel(parent: self)
        root = signInController
        let navigation = UINavigationController(rootViewController: root)
        navigation.isToolbarHidden = true

        return navigation
    }
    
    func presentSignUp() {
        if let signUpVC: SignUpViewController = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController {
            
            let model: SignUpModel = SignUpModel(parent: self)
            model.output = signUpVC
            signUpVC.model = model
            root.navigationController?.pushViewController(signUpVC, animated: true)
        }
    }
    
    func presentConfirmSMS(phone: String) {
        if let confirmVC: ConfirmCodeViewController = storyboard.instantiateViewController(withIdentifier: "ConfirmCodeViewController") as? ConfirmCodeViewController {
            
            confirmVC.model = ConfirmCodeModel(phone: phone)
            root.navigationController?.pushViewController(confirmVC, animated: true)
        }
    }
  
    private func popController() {
        root.navigationController?.popViewController(animated: true)
    }
}
