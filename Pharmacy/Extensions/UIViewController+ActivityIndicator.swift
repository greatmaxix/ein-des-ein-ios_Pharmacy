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
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()
        activityIndicator.tag = indicatorTag
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func hideActivityIndicator() {
        view.subviews.first(where: {$0.tag == indicatorTag})?.removeFromSuperview()
    }
}
