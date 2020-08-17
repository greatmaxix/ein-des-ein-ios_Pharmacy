//
//  UIImage+Blur.swift
//  Pharmacy
//
//  Created by CGI-Kite on 14.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

extension UIImage {

    func bluredImage(sigma: Double) -> UIImage? {
        
        if var ciImage = CIImage(image: self) {

            ciImage = ciImage.applyingGaussianBlur(sigma: sigma)
            let extent = ciImage.extent
            let space = abs(ciImage.extent.origin.x)
            let rect = CGRect(x: 0, y: 0, width: extent.width - space * 2, height: extent.height - space * 2)
            let croppedImage = ciImage.cropped(to: rect)
            return UIImage(ciImage: croppedImage)
        }
        return nil
    }
}
