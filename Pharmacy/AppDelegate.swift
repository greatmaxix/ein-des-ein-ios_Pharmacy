//
//  AppDelegate.swift
//  Pharmacy
//
//  Created by CGI-Kite on 15.06.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var appNavigationCoordinator: AppNavigation!

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        window = UIWindow(frame: UIScreen.main.bounds)

        appNavigationCoordinator = AppNavigation(window: window!)
        appNavigationCoordinator.startFlow()

        return true
    }
}
