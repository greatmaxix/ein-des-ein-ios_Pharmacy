//
//  FarmacyCell.swift
//  Pharmacy
//
//  Created by CGI-Kite on 03.07.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

class FarmacyCell: BaseTableViewCell {
    
    @IBOutlet private weak var farmacyImageView: UIImageView!
    @IBOutlet private weak var likeImageView: UIImageView!

    @IBOutlet private weak var receipeButton: UIButton!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var typeLabel: UILabel!
    @IBOutlet private weak var factoryLabel: UILabel!
    @IBOutlet private weak var costLabel: UILabel!
    
    var addToFavoritesHandler: (() -> Void)?
    var addToPurchesesHandler: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction private func likeFarmacy() {
        likeImageView.isHighlighted = !likeImageView.isHighlighted
    }
}
