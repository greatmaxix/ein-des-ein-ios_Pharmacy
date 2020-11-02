//
//  UIViewController+Alert.swift
//  Pharmacy
//
//  Created by CGI-Kite on 26.06.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit
import MBProgressHUD

struct AlertAction {
    let title: String
    let callback: () -> Void
}

extension UIViewController {
    
    func setupActivityIndicator() -> MBProgressHUD{
        let hud = MBProgressHUD(view: view)
        hud.backgroundView.style = .solidColor
        hud.backgroundView.color = UIColor.black.withAlphaComponent(0.2)
        hud.removeFromSuperViewOnHide = false
        view.addSubview(hud)
        return hud
    }
    
    func showError(title: String = "Error", message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action: UIAlertAction = UIAlertAction(title: "Ok", style: .cancel, handler: { _ in
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
    
    func blurScreenshotView() -> UIView {
        let image = takeScreenshot().withGaussianBlur()
        let visualView = UIImageView(image: image)
        visualView.frame = view.bounds
        visualView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        visualView.tintColor = R.color.textDarkBlue()?.withAlphaComponent(0.2)
        return visualView
    }
    
    func showAlert(title: String, message: String, action: AlertAction, cancelStyleAction: AlertAction, hasBlurBackground: Bool = true ) {
        
        let visualEffectView = hasBlurBackground ? blurScreenshotView() : nil
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
    
}
