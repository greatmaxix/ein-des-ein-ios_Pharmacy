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
  }

  func createFlow() -> UIViewController {
    // swiftlint:disable force_cast
    let signInController = storyboard.instantiateViewController(
        withIdentifier: "SignInViewController") as! SignInViewController
    // swiftlint:enable force_cast

    // Create model here

    root = signInController
    let navigation = UINavigationController(rootViewController: root)
    navigation.isToolbarHidden = true

    return navigation
  }

  private func popController() {
    root.navigationController?.popViewController(animated: true)
  }

}
