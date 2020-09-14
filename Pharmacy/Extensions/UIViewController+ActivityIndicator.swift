//
//  UIViewController+ActivityIndicator.swift
//  Pharmacy
//
//  Created by CGI-Kite on 10.09.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

protocol ActivityIndicatorDelegate: class {
    
    var activityIndicator: UIActivityIndicatorView {get}
    func showActivityIndicator()
    func hideActivityIndicator()
    func setupActivityIndicator()
}

extension ActivityIndicatorDelegate where Self: UIViewController {
    
    func setupActivityIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()
        
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func showActivityIndicator() {        
        activityIndicator.startAnimating()
    }
    
    func hideActivityIndicator() {
        activityIndicator.stopAnimating()
    }
}
