//
//  UIViewController+ActivityIndicator.swift
//  Pharmacy
//
//  Created by CGI-Kite on 10.09.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit
import MBProgressHUD

protocol ActivityIndicatorDelegate: class {
    
    var activityIndicator: UIActivityIndicatorView { get }
    func showActivityIndicator()
    func hideActivityIndicator()
    func setupActivityIndicator()
}

extension ActivityIndicatorDelegate where Self: UIViewController {
    
    func setupActivityIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func showActivityIndicator() {        
        activityIndicator.startAnimating()
        view.isUserInteractionEnabled = false
    }
    
    func hideActivityIndicator() {
        activityIndicator.stopAnimating()
        view.isUserInteractionEnabled = true
    }
}

extension UIViewController {
    func showActivityIndicator() {
        MBProgressHUD.showAdded(to: view, animated: true)
        
    }
    func hideActivityIndicator() {
        MBProgressHUD.hide(for: view, animated: true)
    }
}
