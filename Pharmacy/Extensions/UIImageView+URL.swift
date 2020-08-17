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
    func loadImageBy(url: URL) {
        kf.indicatorType = .activity
        kf.setImage(with: url)
    }
}
