//
//  ChatGalleryCollectionViewCell.swift
//  Pharmacy
//
//  Created by Egor Bozko on 10.11.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit
import Photos

class ChatGalleryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var contentImage: UIImageView!
    @IBOutlet weak var checkboxButton: UIButton!
    @IBOutlet weak var cameraView: UIView!
    
    var image: LibraryImage? {
        didSet {
            contentImage.image = image?.placeholder
        }
    }
    
    override var isSelected: Bool {
        didSet {
            checkboxButton.isSelected = isSelected
        }
    }
    
    func applyCameraStyle() {
        cameraView.isHidden = false
        checkboxButton.isHidden = true
        contentImage.isHidden = true
    }
    
    override func prepareForReuse() {
        cameraView.isHidden = true
        contentImage.isHidden = false
        checkboxButton.isHidden = false
    }
    
    func toggleSelection() {
        checkboxButton.isSelected = !checkboxButton.isSelected
        isSelected = checkboxButton.isSelected
    }
    
    func fetchImage(asset: PHAsset, indexPath: IndexPath) {
       let options = PHImageRequestOptions()
       options.version = .original
       PHImageManager.default().requestImageData(for: asset, options: options) {[weak self](data, _, _, info) in
            guard let d = data else { return }
            self?.image = LibraryImage(data: d, info: info, source: .gallery(indexPath))
       }
    }
}
