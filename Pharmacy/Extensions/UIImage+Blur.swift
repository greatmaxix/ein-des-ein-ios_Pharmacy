//
//  UIImage+Blur.swift
//  Pharmacy
//
//  Created by Anton Bal’ on 18.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

extension UIImage {
    func withGaussianBlur() -> UIImage? {
        if let ciImg = CIImage(image: self) {
            ciImg.applyingGaussianBlur(sigma: 0.5)
            return UIImage(ciImage: ciImg)
        }
        return nil
    }
}
