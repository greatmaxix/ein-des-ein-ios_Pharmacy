//
//  ChatApplicationCollectionViewCell.swift
//  Pharmacy
//
//  Created by Egor Bozko on 10.11.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

class ChatApplicationCollectionViewCell: UICollectionViewCell {
    
    struct GUI {
        static let cornerRadius: CGFloat = 24.0
    }
    @IBOutlet weak var leadingImageConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var trailingImageConstraint: NSLayoutConstraint!
    @IBOutlet weak var applicationImage: UIImageView! {
        didSet {
            applicationImage.contentMode = .scaleAspectFill
            applicationImage.layer.cornerRadius = GUI.cornerRadius
            applicationImage.layer.masksToBounds = true
        }
    }
    
    func apply(attachment: FileAttachment, isFromCurrentSender: Bool) {
        guard let url = URL(string: attachment.url) else { return }
        applicationImage.loadImageBy(url: url)
        if isFromCurrentSender {
            applicationImage.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
            leadingImageConstraint.constant = 40.0
            trailingImageConstraint.constant = 8.0
        } else {
            applicationImage.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMaxXMaxYCorner]
            leadingImageConstraint.constant = 8.0
            trailingImageConstraint.constant = 40.0
        }
    }
}
