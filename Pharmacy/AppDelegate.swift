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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private var appNavigationCoordinator: AppNavigation!

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        _ = NSPersistentContainer.container

        GMSServices.provideAPIKey("AIzaSyDJfvTblScxj6gZYw-Xtg1NJeHbHUcAURs")
        window = UIWindow(frame: UIScreen.main.bounds)

        appNavigationCoordinator = AppNavigation(window: window!)
        appNavigationCoordinator.startFlow()

        return true
    }
}
