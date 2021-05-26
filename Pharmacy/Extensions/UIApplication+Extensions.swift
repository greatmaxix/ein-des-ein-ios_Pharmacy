//
//  UIApplication+Extensions.swift
//  Pharmacy
//
//  Created by Daniiar Erkinov on 26/5/21.
//  Copyright © 2021 pharmacy. All rights reserved.
//

import UIKit

extension UIApplication {
    struct Constants {
        static let CFBundleShortVersionString = "CFBundleShortVersionString"
    }
    class func appVersion() -> String {
        return Bundle.main.infoDictionary?[Constants.CFBundleShortVersionString] as! String
    }
  
    class func appBuild() -> String {
        return Bundle.main.infoDictionary?[kCFBundleVersionKey as String] as! String
    }
  
    class func versionBuild() -> String {
        let version = appVersion(), build = appBuild()
        return version == build ? "\(version)" : "\(version) (\(build))"
    }
}
