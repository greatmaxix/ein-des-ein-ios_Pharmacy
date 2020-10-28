//
//  LightRoundedButton.swift
//  Pharmacy
//
//  Created by Egor Bozko on 28.10.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

final class LightRoundedButton: UIButton {
    
    override func layerWillDraw(_ layer: CALayer) {
        super.layerWillDraw(layer)
        layer.cornerRadius = layer.bounds.height / 2
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.red.cgColor
    }
}
