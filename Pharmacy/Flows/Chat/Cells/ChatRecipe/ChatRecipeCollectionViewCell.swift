//
//  ChatReceiptCollectionViewCell.swift
//  Pharmacy
//
//  Created by Egor Bozko on 16.11.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

class ChatRecipeCollectionViewCell: UICollectionViewCell {
    
    struct GUI {
        static let leadingInset: CGFloat = 11.0
        static let trailingInset: CGFloat = 84.0
    }
    private var actionHandler: (() -> Void)?
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var trailingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var leftPfdIcon: UIImageView!
    @IBOutlet weak var rightPdfIcon: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var decorationView: UIView! {
        didSet {
            decorationView.layer.cornerRadius = 24.0
            decorationView.layer.masksToBounds = true
        }
    }
    
    func apply(receipt: ChatRecipe, isFromCurrentSender: Bool, actionHandler: @escaping (() -> Void) ) {
        self.actionHandler = actionHandler
        nameLabel.text = receipt.originalFilename
        if isFromCurrentSender {
            nameLabel.textAlignment = .right
            leftPfdIcon.isHidden = true
            rightPdfIcon.isHidden = false
            decorationView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMinXMaxYCorner]
            leadingConstraint.constant = GUI.trailingInset
            trailingConstraint.constant = GUI.leadingInset
        } else {
            leadingConstraint.constant = GUI.leadingInset
            trailingConstraint.constant = GUI.trailingInset
            nameLabel.textAlignment = .left
            leftPfdIcon.isHidden = false
            rightPdfIcon.isHidden = true
            decorationView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMaxXMaxYCorner]
        }
    }
    
    @IBAction func downloadPDF(_ sender: Any) {
        actionHandler?()
    }
}
