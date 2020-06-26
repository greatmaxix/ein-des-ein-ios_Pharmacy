//
//  UIViewController+Alert.swift
//  Pharmacy
//
//  Created by CGI-Kite on 26.06.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showAlertVC(title: String) {
        let alertVC = UIAlertController(title: "Error", message: title, preferredStyle: .alert)
        let action: UIAlertAction = UIAlertAction(title: "Ok", style: .default, handler: { _ in
            alertVC.dismiss(animated: true, completion: nil)
        })
        alertVC.addAction(action)
        present(alertVC, animated: true, completion: nil)
    }
    
    func showSpinner(isUserInteractionEnabled: Bool = false) {
        
        view.subviews.first(where: {$0.tag == "spiner".hash})?.removeFromSuperview()
        view.isUserInteractionEnabled = isUserInteractionEnabled
        
        let spiner = UIActivityIndicatorView(style: .gray)
    
        spiner.tag = "spiner".hash
        spiner.center = view.center
        spiner.startAnimating()
        view.addSubview(spiner)
    }
    
    func removeSpinner(isUserInteractionEnabled: Bool = true) {
        
        view.isUserInteractionEnabled = isUserInteractionEnabled
        view.subviews.first(where: {$0.tag == "spiner".hash})?.removeFromSuperview()
    }
}
