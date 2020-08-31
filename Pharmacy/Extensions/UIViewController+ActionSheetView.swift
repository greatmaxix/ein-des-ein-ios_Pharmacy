//
//  UIViewController+ActionSheetView.swift
//  Pharmacy
//
//  Created by Anton Bal’ on 19.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

extension UIViewController {
    func showActionSheetView(content: UIView) {
        hideActionSheetView()
        ActionSheetView(content: content).show(in: view)
        hideActionByTap()
    }
    
    func hideActionSheetView() {
        ActionSheetView.hide(in: view)
    }
    
    func hideActionByTap() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissActionSheet(gesture:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissActionSheet(gesture: UIGestureRecognizer) {
        view.removeGestureRecognizer(gesture)
        hideActionSheetView()
    }
}
