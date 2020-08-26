//
//  AppDelegate.swift
//  Pharmacy
//
//  Created by CGI-Kite on 15.06.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private var appNavigationCoordinator: AppNavigation!

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        //GMSServices.provideAPIKey("")
        window = UIWindow(frame: UIScreen.main.bounds)

        appNavigationCoordinator = AppNavigation(window: window!)
        appNavigationCoordinator.startFlow()

        return true
    }
}
