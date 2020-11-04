//
//  LightRoundedButton.swift
//  Pharmacy
//
//  Created by Egor Bozko on 28.10.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

@IBDesignable class RoundedButton: UIButton {
    @IBInspectable var borderColor: UIColor = UIColor.white {
            didSet {
                self.layer.borderColor = borderColor.cgColor
            }
        }

        @IBInspectable var borderWidth: CGFloat = 2.0 {
            didSet {
                self.layer.borderWidth = borderWidth
            }
        }

        @IBInspectable var cornerRadius: CGFloat = 0.0 {
            didSet {
                self.layer.cornerRadius = cornerRadius
            }
        }
}
