//
//  UIViewController+Keyboard.swift
//  Pharmacy
//
//  Created by Anton Bal’ on 18.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

typealias KeyboardCallback = (KeyboardEvent) -> Void

private enum KeyboardCallbackKeys {
    static var callback = "callback"
}

private struct KeyboardInfo {
    let rect: CGRect
    let duration: Double
    let curve: UIView.AnimationOptions
}

enum KeyboardEvent {
    case willShow(CGRect)
    case willHide(CGRect)
}

extension UIViewController {
    
    func subscribeToNotification(_ notification: NSNotification.Name, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: notification, object: nil)
    }
    
    func subscribeToKeyboard(callback: @escaping KeyboardCallback) {
        self.callback = callback
        subscribeToNotification(UIResponder.keyboardWillShowNotification, selector: #selector(keyboardWillShow))
        subscribeToNotification(UIResponder.keyboardWillHideNotification, selector: #selector(keyboardWillHide))
    }
    
    func subscribeToKeyboard() {
        let initalContentInset = additionalSafeAreaInsets
        subscribeToKeyboard { event in
            var contentInset = initalContentInset
            switch event {
            case .willHide: break
            case .willShow(let rect):
                let keyboardOverlap = self.view.frame.maxY - rect.origin.y
                contentInset.bottom = keyboardOverlap
            }
            self.additionalSafeAreaInsets = contentInset
        }
    }
    
    func subscribeScrollViewToKeyboard(_ scrollView: UIScrollView, with initialContentInset: UIEdgeInsets = .zero) {
        subscribeToKeyboard { event in
            var contentInset = initialContentInset
            switch event {
            case .willHide: break
            case .willShow(let rect):
                let keyboardOverlap = scrollView.frame.maxY - rect.origin.y
                contentInset.bottom = keyboardOverlap
            }
            scrollView.contentInset = contentInset
            scrollView.scrollIndicatorInsets = contentInset
        }
    }
    
    func hideKeyboardByTap() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissMyKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
     @objc private func dismissMyKeyboard() {
        view.endEditing(true)
    }
    
     @objc private func keyboardWillShow(notification: NSNotification) {
        guard let info = keyboardInfoFrom(notification: notification) else { return }
        
        UIView.animate(withDuration: info.duration, delay: 0, options: info.curve, animations: {
            self.callback(.willShow(info.rect))
        })
       }
    
     @objc private func keyboardWillHide(notification: NSNotification) {
        guard let info = keyboardInfoFrom(notification: notification) else { return }
        UIView.animate(withDuration: info.duration, delay: 0, options: info.curve, animations: {
            self.callback(.willHide(info.rect))
        })
    }
    
    private func keyboardInfoFrom(notification: NSNotification) -> KeyboardInfo? {
        guard let userInfo = notification.userInfo,
            let endValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey],
            let durationValue = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey],
            let curveValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey]  else { return nil}
        let rect = view.convert((endValue as AnyObject).cgRectValue, from: view.window)
        let duration = (durationValue as AnyObject).doubleValue
        let options = UIView.AnimationOptions(rawValue: UInt((curveValue as AnyObject).integerValue << 16))
            
        return KeyboardInfo(rect: rect, duration: duration!, curve: options)
    }
    
    fileprivate var callback: KeyboardCallback {
        get { getAssociatedObject(key: &KeyboardCallbackKeys.callback)! }
        set { setAssociatedObject(value: newValue, key: &KeyboardCallbackKeys.callback, policy: .retain) }
    }
}
