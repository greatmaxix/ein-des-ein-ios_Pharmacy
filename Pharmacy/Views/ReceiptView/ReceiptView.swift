//
//  ReceiptView.swift
//  Pharmacy
//
//  Created by Anton Bal’ on 11.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

final class ReceiptView: UIView {
    
    enum GUI {
        static let cornerRadius: CGFloat = 8
    }
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet private weak var receiptButton: UIButton!
    
    func apply(receipt: Receipt) {
        titleLabel.text = receipt.title
        subtitleLabel.text = receipt.subtitle
        priceLabel.text = receipt.price
        priceLabel.attributedText = NSAttributedString.fromPriceAttributed(for: receipt.price, currency: receipt.currency)
        
        if let url = receipt.imageURL {
            imageView.loadImageBy(url: url)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = GUI.cornerRadius
        containerView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        containerView.dropBlueShadow()
    }
    
    // MARK: - Actions
    
    @IBAction func likeAction(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
    @IBAction func addToBag(_ sender: UIButton) {
    }
}
