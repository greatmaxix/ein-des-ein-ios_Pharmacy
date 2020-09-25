//
//  UIImageView.swift
//  Pharmacy
//
//  Created by Anton Bal’ on 12.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit
import Kingfisher

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
