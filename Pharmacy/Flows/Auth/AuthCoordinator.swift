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
            case .back:
                self?.popController()
            }
        }
        
        addHandler { [weak self] (event: SignUpEvent) in
            switch event {
            case .receiveCode(let phone):
                self?.presentConfirmSMS(phone: phone,
                                        congratulationNeeded: true)
            case .close:
                self?.popController()
            }
        }
        
        addHandler { [weak self] (event: ConfirmCodeEvent) in
            switch event {
            case .congratulation:
                //self?.presentCongratulation(
                break
            case .close:
                self?.popController()
            case .back:
                self?.popController()
            default:
                break
            }
        }
    }

    func createFlow() -> UIViewController {
        // swiftlint:disable force_cast
        let signInController = storyboard.instantiateViewController(
            withIdentifier: "SignInViewController") as! SignInViewController
        // swiftlint:enable force_cast

        let model: SignInModel = SignInModel(parent: self)
        model.output = signInController
        signInController.model = model
        
        root = signInController
        let navigation = UINavigationController(navigationBarClass: SimpleNavigationBar.self, toolbarClass: nil)
        navigation.setViewControllers([root], animated: true)
        navigation.isToolbarHidden = true
        navigation.navigationBar.isHidden = true

        return navigation
    }
    
    private func presentSignUp() {
        if let signUpVC: SignUpViewController = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController {
            
            let model: SignUpModel = SignUpModel(parent: self)
            model.output = signUpVC
            signUpVC.model = model
            root.navigationController?.navigationBar.isHidden = true
            root.navigationController?.pushViewController(signUpVC, animated: true)
        }
    }
    
    private func presentConfirmSMS(phone: String, congratulationNeeded: Bool = false) {
        if let confirmVC: ConfirmCodeViewController = storyboard.instantiateViewController(withIdentifier: "ConfirmCodeViewController") as? ConfirmCodeViewController {
            
            let model = ConfirmCodeModel(parent: self,
                                         phone: phone,
                                         congratulatioNeeded: congratulationNeeded)
            confirmVC.model = model
            model.output = confirmVC
            root.navigationController?.pushViewController(confirmVC, animated: true)
        }
    }
  
    private func popController() {
        root.navigationController?.popViewController(animated: true)
    }
}
