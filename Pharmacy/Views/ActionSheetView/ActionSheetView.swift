//
//  ActionSheetView.swift
//  Pharmacy
//
//  Created by Anton Bal’ on 19.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

final class ActionSheetView: UIView {

    private enum GUI {
        static let contentInset = UIEdgeInsets.only(top: 22, bottom: 17)
        static let shapeTopMargin: CGFloat = 6
        static let cornerRadius: CGFloat = 8
        static let shapeSize = CGSize(width: 40, height: 4)
        static let animationDuration: TimeInterval = 0.3
    }
    
    init(content: UIView) {
        var rect = content.bounds
        rect.size.height += GUI.contentInset.top + GUI.contentInset.bottom
        
        super.init(frame: rect)
        commonInit()
        content.frame.origin.y = GUI.contentInset.top
        content.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(content)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        let origin = CGPoint(x: bounds.midX - GUI.shapeSize.width / 2, y: GUI.shapeTopMargin)
        let shape = UIView(frame: CGRect(origin: origin, size: GUI.shapeSize))
        shape.layer.cornerRadius = shape.frame.height / 2
        shape.backgroundColor = R.color.shapeColor()
        shape.autoresizingMask = [.flexibleWidth, .flexibleHeight ]
        addSubview(shape)
        
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        layer.cornerRadius = GUI.cornerRadius
        backgroundColor = .white
    }
    
    func hide() {
        guard let superview = superview else { return }
        
        UIView.animate(withDuration: GUI.animationDuration, animations: {
            self.frame.origin.y = superview.frame.height
        }, completion: { _ in
            self.removeFromSuperview()
        })
    }
    
    func show(in view: UIView) {
        frame.origin.y = view.frame.height
        frame.size.width = view.frame.width
        
        view.addSubview(self)
        UIView.animate(withDuration: GUI.animationDuration) {
            self.frame.origin.y = view.frame.height - self.frame.height
        }
    }
    
    static func hide(in mainView: UIView) {
        for item in mainView.subviews {
            if let view = item as? ActionSheetView {
                view.hide()
            }
        }
    }
}
