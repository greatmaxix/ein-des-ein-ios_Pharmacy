//
//  ChatGalleryCollectionViewCell.swift
//  Pharmacy
//
//  Created by Egor Bozko on 10.11.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

class ChatGalleryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var contentImage: UIImageView!
    @IBOutlet weak var checkboxButton: UIButton!
    
    override var isSelected: Bool {
        didSet {
            checkboxButton.isSelected = isSelected
        }
    }
}
