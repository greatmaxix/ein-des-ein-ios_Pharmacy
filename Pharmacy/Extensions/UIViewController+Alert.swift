//
//  UIViewController+Alert.swift
//  Pharmacy
//
//  Created by CGI-Kite on 26.06.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

struct AlertAction {
    let title: String
    let callback: ()->Void
}

extension UIViewController {
    
    func showError(message: String) {
        let alertVC = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action: UIAlertAction = UIAlertAction(title: "Ok", style: .default, handler: { _ in
            alertVC.dismiss(animated: true, completion: nil)
        })
        alertVC.addAction(action)
        present(alertVC, animated: true, completion: nil)
    }
    
    func takeScreenshot() -> UIImage {
        defer { UIGraphicsEndImageContext() }
        
        let layer = view.layer
        UIGraphicsBeginImageContext(layer.frame.size)
        if let context = UIGraphicsGetCurrentContext() {
            layer.render(in: context)
        }
        
        return UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
    }
    
    func blurView() -> UIView {
        let image = takeScreenshot().withGaussianBlur()
        let visualView = UIImageView(image: image)
        visualView.frame = view.bounds
        visualView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        visualView.tintColor = R.color.textDarkBlue()?.withAlphaComponent(0.2)
        return visualView
    }
    
    func showAlert(title: String, message: String, action: AlertAction, cancelStyleAction: AlertAction, hasBlurBackground: Bool = true ) {
        
        let visualEffectView = hasBlurBackground ? blurView() : nil
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let uiAction = UIAlertAction(title: action.title, style: .default, handler: { _ in
            visualEffectView?.removeFromSuperview()
            alertVC.dismiss(animated: true, completion: nil)
            action.callback()
        })
        alertVC.addAction(uiAction)
        
        let uiCancelAction = UIAlertAction(title: cancelStyleAction.title, style: .cancel, handler: { _ in
            visualEffectView?.removeFromSuperview()
            alertVC.dismiss(animated: true, completion: nil)
            cancelStyleAction.callback()
        })
        alertVC.addAction(uiCancelAction)
        
        if let visualEffectView = visualEffectView {
            view.addSubview(visualEffectView)
        }
        
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
