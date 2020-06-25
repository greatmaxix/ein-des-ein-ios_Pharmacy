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
}
