//
//  UIButton.swift
//  KyivPost
//
//  Created by Anton Bal’ on 26.07.2020.
//  Copyright © 2020 KyivPost. All rights reserved.
//

import UIKit

extension UIButton {
    func setTrailingImageViewWith(padding: CGFloat) {
        if let buttomImageView = imageView {
            buttomImageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                buttomImageView.leadingAnchor.constraint(equalTo: trailingAnchor,
                                          constant: padding),
                centerYAnchor.constraint(equalTo: buttomImageView.centerYAnchor)
            ])
        }
    }
}
