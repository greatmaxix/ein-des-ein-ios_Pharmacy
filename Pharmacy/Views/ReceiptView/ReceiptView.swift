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
    
    private(set) var productId: Int!
    private(set) var currentMedicineEntity: Medicine!
    
    var likeActionHandler: ((_ state: Bool) -> Void)?
    var addToChartHandler: EmptyClosure?
    
    func apply(receipt: Medicine) {
        self.currentMedicineEntity = receipt
        titleLabel.text = receipt.title
        likeButton.isSelected = receipt.liked
        subtitleLabel.text = receipt.releaseForm
        priceLabel.text = receipt.maxPrice!.moneyString()
        productId = receipt.id
        priceLabel.attributedText = NSAttributedString.fromRecentsPriceAttributed(for: receipt.price)
    
        if let url = receipt.imageURL {
            imageView.loadImageBy(url: url)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = GUI.cornerRadius
        containerView.dropBlueShadow()
    }
    
    // MARK: - Actions
    
    @IBAction func likeAction(_ sender: UIButton) {
        likeActionHandler?(!sender.isSelected)
        sender.isSelected.toggle()
    }
    @IBAction func addToBag(_ sender: UIButton) {
        self.addToChartHandler?()
    }
}
