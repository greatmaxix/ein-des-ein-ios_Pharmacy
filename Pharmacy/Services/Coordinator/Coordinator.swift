//
//  Coordinator.swift
//  Pharmacy
//
//  Created by Mikhail Timoscenko on 16.06.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import UIKit

public protocol Coordinator {
    func createFlow() -> UIViewController
}

public protocol NavigationCoordinator {
    var navigation: UINavigationController { get }
}

public protocol NaviagationEmbedCoordinable: NavigationCoordinator {
    var navigationCoordinator: NavigationCoordinator { get }
}

extension NaviagationEmbedCoordinable {
    var navigation: UINavigationController { navigationCoordinator.navigation }
}
