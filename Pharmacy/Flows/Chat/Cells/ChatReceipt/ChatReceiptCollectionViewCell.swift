//
//  ChatReceiptCollectionViewCell.swift
//  Pharmacy
//
//  Created by Egor Bozko on 16.11.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

class ChatReceiptCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var leftPfdIcon: UIImageView!
    @IBOutlet weak var rightPdfIcon: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var decorationView: UIView! {
        didSet {
            decorationView.layer.cornerRadius = 10.0
            decorationView.layer.masksToBounds = true
        }
    }
    
    func apply(receipt: ChatReceipt, isFromCurrentSender: Bool) {
        nameLabel.text = receipt.fileName
        if isFromCurrentSender {
            nameLabel.textAlignment = .right
            leftPfdIcon.isHidden = true
            rightPdfIcon.isHidden = false
            decorationView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMinXMaxYCorner]
        } else {
            nameLabel.textAlignment = .left
            leftPfdIcon.isHidden = false
            rightPdfIcon.isHidden = true
            decorationView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMaxXMaxYCorner]
        }
    }
}
