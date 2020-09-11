//
//  UIViewController+ActivityIndicator.swift
//  Pharmacy
//
//  Created by CGI-Kite on 10.09.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

protocol ActivityIndicatorDelegate: class {
    func showActivityIndicator(activityIndicator: UIActivityIndicatorView)
    func hideActivityIndicator(activityIndicator: UIActivityIndicatorView)
}

extension ActivityIndicatorDelegate where Self: UIViewController {
    
    func showActivityIndicator(activityIndicator: UIActivityIndicatorView) {
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func hideActivityIndicator(activityIndicator: UIActivityIndicatorView) {
        activityIndicator.removeFromSuperview()
    }
}
