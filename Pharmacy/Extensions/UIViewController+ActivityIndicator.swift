//
//  UIViewController+ActivityIndicator.swift
//  Pharmacy
//
//  Created by CGI-Kite on 10.09.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

extension UIViewController {
    private var indicatorTag: Int {
        Int(1e07)
    }
    
    func showActivityIndicator() {
        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
        activityIndicator.startAnimating()
        activityIndicator.center = view.center
        activityIndicator.tag = indicatorTag
        view.addSubview(activityIndicator)
        view.bringSubviewToFront(activityIndicator)
    }
    
    func hideActivityIndicator() {
        view.subviews.first(where: {$0.tag == indicatorTag})?.removeFromSuperview()
    }
}
