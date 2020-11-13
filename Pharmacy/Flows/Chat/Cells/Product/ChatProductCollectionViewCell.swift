//
//  ChatProductCollectionViewCell.swift
//  Pharmacy
//
//  Created by Egor Bozko on 09.11.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

enum ChatProductAction {
    case likeToggle, openProduct
}

typealias ChatProductHandler = (ChatProductAction) -> Void

class ChatProductCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var trailingConstraint: NSLayoutConstraint!
    
    var actionHandler: ChatProductHandler?
    
    func apply(product: Product, actionHandler: @escaping ChatProductHandler) {
        if let url = product.imageURLs.first {
            productImage.loadImageBy(url: url)
        }
        nameLabel.text = product.name
        detailsLabel.text = product.releaseForm
        priceLabel.text = product.minPrice
        
        self.actionHandler = actionHandler
    }
    
    @IBAction func toggleButton(_ sender: Any) {
        actionHandler?(.likeToggle)
    }
}
