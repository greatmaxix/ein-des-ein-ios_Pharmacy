//
//  AppDelegate.swift
//  Pharmacy
//
//  Created by CGI-Kite on 15.06.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreData
import Firebase
import IQKeyboardManager

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private var appNavigationCoordinator: AppNavigation!

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        CoreDataService.shared.setup()
        FirebaseApp.configure()
        GMSServices.provideAPIKey("AIzaSyDJfvTblScxj6gZYw-Xtg1NJeHbHUcAURs")
        window = UIWindow(frame: UIScreen.main.bounds)
        appNavigationCoordinator = AppNavigation(window: window!)
        NetworkActivityLogger.shared.level = .debug
        NetworkActivityLogger.shared.startLogging()
        IQKeyboardManager.shared().isEnabled = true
        appNavigationCoordinator.startFlow()

        return true
    }
}

