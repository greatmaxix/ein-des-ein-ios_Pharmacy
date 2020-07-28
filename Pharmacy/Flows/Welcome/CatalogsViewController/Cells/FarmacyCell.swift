//
//  FarmacyCell.swift
//  Pharmacy
//
//  Created by CGI-Kite on 03.07.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

class FarmacyCell: BaseTableViewCell {
    
    @IBOutlet weak var farmacyImageView: UIImageView!
    @IBOutlet weak var likeImageView: UIImageView!

    @IBOutlet weak var receipeButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var factoryLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    
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
