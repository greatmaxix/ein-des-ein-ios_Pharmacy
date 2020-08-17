//
//  RoundedCornerNavigationBar.swift
//  Pharmacy
//
//  Created by Anton Bal’ on 08.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import UIKit

protocol RoundedCornerNavigationBar {
    func addRoundedCornerTo(_ navigationBar: UINavigationBar, cornerRadius: CGFloat)
}

extension RoundedCornerNavigationBar where Self: UIViewController{
    
    func addRoundedCornerTo(_ navigationBar: UINavigationBar, cornerRadius: CGFloat){
//         navigationBar.isTranslucent = false
//        navigationBar.setBackgroundImage(UIImage(), for: .default)
//        navigationBar.backgroundColor = .white
        
        navigationBar.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        navigationBar.clipsToBounds = false
        navigationBar.backgroundColor = .red
       let view =  UIView(frame: navigationBar.frame)
        view.backgroundColor = .red
        
//        navigationBar.insertSubview(view, aboveSubview: navigationBar.subviews[2])
//        navigationBar.addSubview(view)
//
//        let customView = UIView(frame: CGRect(x: 0, y: navigationBar.bounds.maxY, width: navigationBar.bounds.width, height: 4.0))
//        customView.backgroundColor = .clear
//        navigationBar.insertSubview(customView, at: 0)
//
//        let shapeLayer = CAShapeLayer()
//        shapeLayer.path = UIBezierPath(roundedRect: customView.bounds, byRoundingCorners: [.bottomLeft,.bottomRight], cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).cgPath
////        shapeLayer.shadowColor = UIColor.lightGray.cgColor
////        shapeLayer.shadowOffset = CGSize(width: 0, height: 4.0)
////        shapeLayer.shadowOpacity = 0.8
////        shapeLayer.shadowRadius = 2
//        shapeLayer.fillColor = UIColor.white.cgColor
//        customView.layer.insertSublayer(shapeLayer, at: 0)
    }
    
    func setup(navigationBar: UINavigationBar) {
       // addRoundedCornerTo(navigationBar, cornerRadius: 27)
    }
}
