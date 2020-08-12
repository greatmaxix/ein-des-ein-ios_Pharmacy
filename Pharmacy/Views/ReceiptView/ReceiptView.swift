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
    @IBOutlet private weak var actionButton: UIButton!
    @IBOutlet private weak var fromPriceLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet private weak var receiptButton: UIButton!
    
    func apply(receipt: Receipt) {
        titleLabel.text = receipt.title
        subtitleLabel.text = receipt.subtitle
        priceLabel.text = receipt.price
        
        if let url = receipt.imageURL {
//            TODO: load image
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        actionButton.layer.cornerRadius = GUI.cornerRadius
        containerView.layer.cornerRadius = GUI.cornerRadius
        containerView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        containerView.dropBlueShadow()
    }
    
    //MARK: - Actions
    
    @IBAction func priceAction(_ sender: UIButton) {
        
    }
    
    @IBAction func likeAction(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
}
