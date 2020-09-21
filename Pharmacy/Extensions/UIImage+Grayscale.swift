//
//  UIImage+Grayscale.swift
//  Pharmacy
//
//  Created by Sapa Denys on 21.09.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

extension UIImage {
    
    func grayscaled() -> UIImage? {
        let context = CIContext(options: nil)
        if let filter = CIFilter(name: "CIPhotoEffectMono") {
            filter.setValue(CIImage(image: self), forKey: kCIInputImageKey)
            if let output = filter.outputImage {
                if let cgImage = context.createCGImage(output, from: output.extent) {
                    return UIImage(cgImage: cgImage)
                }
            }
        }
        
        return nil
    }
    
}
