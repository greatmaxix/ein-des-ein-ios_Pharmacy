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
                break
            case .signUp:
                self?.routeToSignUp()
            }
        }
    }

    func createFlow() -> UIViewController {
        // swiftlint:disable force_cast
        let signInController = storyboard.instantiateViewController(
            withIdentifier: "SignInViewController") as! SignInViewController
        // swiftlint:enable force_cast

        signInController.signInInput = SignInViewModel(parent: self)
        root = signInController
        let navigation = UINavigationController(rootViewController: root)
        navigation.isToolbarHidden = true

        return navigation
    }
    
    func routeToSignUp() {
        if let signUpVC: SignUpViewController = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController {
            
            signUpVC.signUpInput = SignUpViewModel(parent: self)
            root.navigationController?.pushViewController(signUpVC, animated: true)
        }
    }
    
    func routeToConfirmSMS() {
        let confirmVC: UIViewController = storyboard.instantiateViewController(withIdentifier: "ConfirmCodeViewController")
        root.navigationController?.pushViewController(confirmVC, animated: true)
    }
  
    private func popController() {
        root.navigationController?.popViewController(animated: true)
    }

}
