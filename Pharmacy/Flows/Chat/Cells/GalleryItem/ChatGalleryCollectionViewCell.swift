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
    @IBOutlet weak var cameraView: UIView!
    
    override var isSelected: Bool {
        didSet {
            checkboxButton.isSelected = isSelected
        }
    }
    
    func applyCameraStyle() {
        cameraView.isHidden = false
        checkboxButton.isHidden = true
    }
    
    override func prepareForReuse() {
        cameraView.isHidden = true
        checkboxButton.isHidden = false
    }
    
    func toggleSelection() {
        checkboxButton.isSelected = !checkboxButton.isSelected
        isSelected = checkboxButton.isSelected
    }
}
