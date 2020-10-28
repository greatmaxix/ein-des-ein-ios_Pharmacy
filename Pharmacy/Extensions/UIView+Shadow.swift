//
//  UIView+Shadow.swift
//  Pharmacy
//
//  Created by CGI-Kite on 25.06.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

extension UIView {
    
    func dropShadow(scale: Bool = true, color: UIColor?, width: CGFloat =  1, height: CGFloat = 1, radius: CGFloat = 1, opacity: Float) {
        layer.masksToBounds = false
        layer.shadowColor = color?.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = CGSize(width: width, height: height)
        layer.shadowRadius = radius
        
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func dropBlueShadow() {
        dropShadow(scale: true, color: R.color.shadowBlue(), width: 0, height: 6, radius: 8, opacity: 0.1)
    }
    
    func bottomViewDropGrayShadow() {
        dropShadow(scale: true, color: R.color.gray(), width: 0, height: -4, radius: 8, opacity: 0.1)
    }
    
    func buttonDropBlueShadow() {
        dropShadow(scale: true, color: R.color.shadowBlue(), width: 0, height: 4, radius: 20, opacity: 0.1)
    }
    
    func dropLightBlueShadow() {
        dropShadow(scale: true, color: R.color.lightBlue(), width: 0, height: 6, radius: 8, opacity: 0.1)
    }
  
    func cellLightBlueShadow() {
        dropShadow(scale: true, color: R.color.lightBlue(), width: 0, height: 0, radius: 2, opacity: 0.1)
    }
    
    func removeShadow() {
        layer.shadowColor = nil
        layer.shadowOpacity = 0
        layer.shadowOffset = CGSize(width: 0, height: -3)
    }
}
