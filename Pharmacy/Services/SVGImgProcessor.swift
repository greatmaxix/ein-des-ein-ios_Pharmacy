//
//  SVGImgProcessor.swift
//  Pharmacy
//
//  Created by Daniiar Erkinov on 4/8/21.
//  Copyright © 2021 pharmacy. All rights reserved.
//

import UIKit
import Kingfisher
import SVGKit

public struct SVGImgProcessor: ImageProcessor {
    public var identifier: String = "com.appidentifier.webpprocessor"
    public func process(item: ImageProcessItem, options: KingfisherParsedOptionsInfo) -> KFCrossPlatformImage? {
        switch item {
        case .image(let image):
            print("already an image")
            return image
        case .data(let data):
            let imsvg = SVGKImage(data: data)
            return imsvg?.uiImage
        }
    }
}
