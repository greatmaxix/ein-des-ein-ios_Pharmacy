//
//  MedicineCell.swift
//  Pharmacy
//
//  Created by CGI-Kite on 03.07.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit
import Kingfisher

final class MedicineCell: HighlightedTableViewCell, NibReusable {
    
    // MARK: - Outlets
    @IBOutlet private weak var farmacyImageView: UIImageView!
    @IBOutlet private weak var likedButton: UIButton!
    @IBOutlet private weak var buyButton: UIButton!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var typeLabel: UILabel!
    @IBOutlet private weak var factoryLabel: UILabel!
    @IBOutlet private weak var costLabel: UILabel!
    
    // MARK: - Properties
    var addToFavoritesHandler: EmptyClosure?
    var addToPurchesesHandler: EmptyClosure?
    
    private var downloadTask: DownloadTask?
    
    // MARK: - Init / Deinit methods
    deinit {
        downloadTask?.cancel()
    }
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        farmacyImageView.layer.cornerRadius = 8
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        downloadTask?.cancel()
    }
    
    // MARK: - Public methods
    func apply(medicine: Medicine) {
        likedButton.isSelected = medicine.liked
        titleLabel.text = medicine.title
        costLabel.text = medicine.price
        typeLabel.text = medicine.releaseFormFormatted
        factoryLabel.text = medicine.manufacturerName
        
        let placeholder: UIImage?
        if medicine.minPrice != nil {
            setAvaliableStyle()
            costLabel.attributedText = NSAttributedString.fromPriceAttributed(for: medicine.price)
            placeholder = R.image.medicineImagePlaceholder()
        } else {
            setUnavaliableStyle()
            costLabel.text = R.string.localize.productTemporarilyUnavailable()
            placeholder = R.image.medicineImageGrayscalePlaceholder()
        }
        
        guard let urlString = medicine.pictureUrls.first,
            let url = URL(string: urlString) else {
                farmacyImageView.image = placeholder
                
                return
        }
        
        downloadTask = farmacyImageView.loadImageBy(url: url,
                                                    placeholder: placeholder) { [unowned self] result in
                                                        switch result {
                                                        case .success(let imageData):
                                                            self.farmacyImageView.backgroundColor = .clear
                                                            if medicine.minPrice == nil {
                                                                self.farmacyImageView.image = imageData.image.grayscaled()
                                                            }
                                                        case .failure:
                                                            self.farmacyImageView.backgroundColor = R.color.mediumGrey()
                                                        }
        }
    }
    
    // MARK: - Actions
    @IBAction private func likeAction(sender: UIButton) {
        sender.isSelected.toggle()
        
        addToFavoritesHandler?()
    }
    
    @IBAction private func buyAction(sender: UIButton) {
        sender.isSelected.toggle()
        
        addToPurchesesHandler?()
    }
}

// MARK: - Private methods
extension MedicineCell {
    
    private func setAvaliableStyle() {
        titleLabel.textColor = R.color.textDarkBlue()
        costLabel.textColor = R.color.textDarkBlue()
        typeLabel.textColor = R.color.textDarkBlue()
        factoryLabel.textColor = R.color.textDarkBlue()
    }
    
    private func setUnavaliableStyle() {
        titleLabel.textColor = R.color.greyText()
        costLabel.textColor = R.color.greyText()
        typeLabel.textColor = R.color.greyText()
        factoryLabel.textColor = R.color.greyText()
        
        costLabel.textColor = R.color.applyBlueGray()
    }
}
