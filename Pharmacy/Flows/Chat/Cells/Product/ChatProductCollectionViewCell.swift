//
//  ChatProductCollectionViewCell.swift
//  Pharmacy
//
//  Created by Egor Bozko on 09.11.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit
import MessageKit
enum ChatProductAction {
    case likeToggle, openProduct
}

typealias ChatProductHandler = (ChatProductAction) -> Void

class ChatProductCollectionViewCell: MessageCollectionViewCell {
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var productContainer: UIView! {
        didSet {
            productContainer.layer.cornerRadius = 10.0
            productContainer.layer.masksToBounds = true
            productContainer.decorationBlackShadow()
        }
    }
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var trailingConstraint: NSLayoutConstraint! {
        didSet {
            trailingConstraint.priority = .defaultLow
        }
    }
    
    var actionHandler: ChatProductHandler?
    
    func apply(product: ChatProduct, actionHandler: @escaping ChatProductHandler, isFromCurrentSender: Bool) {
        if let url = product.pictures.first?.url {
            productImage.loadImageBy(url: url)
        }
        nameLabel.text = product.name
        detailsLabel.text = product.releaseForm
        priceLabel.text = "\(product.priceRange.minPrice)"
        likeButton.isSelected = product.liked
        
        self.actionHandler = actionHandler
        
        if isFromCurrentSender {
            leadingConstraint.priority = .defaultLow
            trailingConstraint.priority = .required
        } else {
            trailingConstraint.priority = .defaultLow
            leadingConstraint.priority = .required
        }
    }
    
    override func handleTapGesture(_ gesture: UIGestureRecognizer) {
        actionHandler?(.openProduct)
    }
    
    @IBAction func toggleButton(_ sender: Any) {
        likeButton.isSelected = !likeButton.isSelected
        actionHandler?(.likeToggle)
    }
}
