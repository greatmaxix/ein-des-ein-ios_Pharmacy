//
//  UIEdgeInsets.swift
//  KyivPost
//
//  Created by Anton Bal’ on 12.07.2020.
//  Copyright © 2020 KyivPost. All rights reserved.
//

import UIKit


extension UIEdgeInsets {
    static func only(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) -> UIEdgeInsets {
        UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
    }
    
    static func all(_ all: CGFloat) -> UIEdgeInsets {
        UIEdgeInsets(top: all, left: all, bottom: all, right: all)
    }
}
