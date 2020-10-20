//
//  UINavigationController.swift
//  Pharmacy
//
//  Created by Sergey berdnik on 20.10.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {
   func isRootViewController() -> Bool{
        self.visibleViewController==self.viewControllers.first
    }
}
