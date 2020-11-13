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
        static let cornerRadius: CGFloat = 10.0
    }
    
    @IBOutlet weak var applicationImage: UIImageView! {
        didSet {
            applicationImage.contentMode = .scaleAspectFill
            applicationImage.layer.cornerRadius = GUI.cornerRadius
            applicationImage.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
            applicationImage.layer.masksToBounds = true
        }
    }
    
    func apply(attachment: FileAttachment) {
        guard let url = URL(string: attachment.url) else { return }
        applicationImage.loadImageBy(url: url)
    }
}
