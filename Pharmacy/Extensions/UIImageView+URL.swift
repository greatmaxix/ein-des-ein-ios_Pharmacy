//
//  UIImageView.swift
//  Pharmacy
//
//  Created by Anton Bal’ on 12.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit
import Kingfisher
import Photos

extension UIImageView {
    
    @discardableResult
    func loadImageBy(url: URL,
                     placeholder: UIImage? = nil,
                     completion: ((Result<RetrieveImageResult, KingfisherError>) -> Void)? = nil) -> DownloadTask? {
        kf.indicatorType = .activity
        return kf.setImage(with: url,
                    placeholder: placeholder,
                    completionHandler: completion)
    }
}

extension UIImageView {
    
 func fetchImage(asset: PHAsset, contentMode: PHImageContentMode, targetSize: CGSize) {
    let options = PHImageRequestOptions()
    options.version = .original
    PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: contentMode, options: options) { image, _ in
        guard let image = image else { return }
        switch contentMode {
        case .aspectFill:
            self.contentMode = .scaleAspectFill
        case .aspectFit:
            self.contentMode = .scaleAspectFit
        default: break
        }
        self.image = image
    }
   }
}
