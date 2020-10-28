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
  
    func withGaussianBlur() -> UIImage? {
        if let ciImg = CIImage(image: self) {
            ciImg.applyingGaussianBlur(sigma: 0.5)
            return UIImage(ciImage: ciImg)
        }
        return nil
    }
    
    func resizeImage(_ dimension: CGFloat, opaque: Bool, contentMode: UIView.ContentMode = .scaleAspectFit) -> UIImage {
                var width: CGFloat
                var height: CGFloat
                var newImage: UIImage

                let size = self.size
                let aspectRatio =  size.width/size.height

                switch contentMode {
                case .scaleAspectFit:
                        if aspectRatio > 1 {                            // Landscape image
                            width = dimension
                            height = dimension / aspectRatio
                        } else {                                        // Portrait image
                            height = dimension
                            width = dimension * aspectRatio
                        }

                default:
                    fatalError("UIIMage.resizeToFit(): FATAL: Unimplemented ContentMode")
                }

                UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), opaque, 0)
                self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
                newImage = UIGraphicsGetImageFromCurrentImageContext()!
                UIGraphicsEndImageContext()

                return newImage
            }
    public func withRoundedCorners(radius: CGFloat = 0) -> UIImage? {
               let maxRadius = min(size.width, size.height) / 2
               let cornerRadius: CGFloat
               if radius > 0 && radius <= maxRadius {
                   cornerRadius = radius
               } else {
                   cornerRadius = maxRadius
               }
               UIGraphicsBeginImageContextWithOptions(size, false, scale)
               let rect = CGRect(origin: .zero, size: size)
               UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).addClip()
               draw(in: rect)
               let image = UIGraphicsGetImageFromCurrentImageContext()
               UIGraphicsEndImageContext()
               return image
           }
}
