//
//  UIViewController+Alert.swift
//  Pharmacy
//
//  Created by CGI-Kite on 26.06.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

extension UIViewController {
    
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
