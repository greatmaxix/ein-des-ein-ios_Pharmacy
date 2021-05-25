//
//  UIViewController+ActivityIndicator.swift
//  Pharmacy
//
//  Created by CGI-Kite on 10.09.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

extension UIViewController {
    func showActivityIndicator() {
        PulseLoaderService.showAdded(to: view)
        
    }
    func hideActivityIndicator() {
        PulseLoaderService.hide(from: view)
    }
}
