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
    var favoriteButtonHandler: ((_ state: Bool) -> Void)?
    
    var addToPurchesesHandler: EmptyClosure?
    
    private(set) var medicineProductID: Int = 0
    
    private var defaultLikedStatus: Bool = false
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
        self.farmacyImageView.backgroundColor = R.color.mediumGrey()
    }
    
    // MARK: - Public methods
    func apply(medicine: Medicine) {
        likedButton.isSelected = medicine.liked
        defaultLikedStatus = medicine.liked
        titleLabel.text = medicine.title
        costLabel.text = medicine.price
        typeLabel.text = medicine.releaseFormFormatted
        factoryLabel.text = medicine.manufacturerName
        medicineProductID = medicine.id
        
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
                                                    placeholder: placeholder) { [weak self] result in
                                                        guard let self = self else {
                                                            return
                                                        }
                                                        
                                                        switch result {
                                                        case .success(let imageData):
                                                            guard medicine.minPrice != nil else {
                                                                self.farmacyImageView.image = imageData.image.grayscaled()
                                                                
                                                                return
                                                            }
                                                            
                                                            self.farmacyImageView.backgroundColor = .clear
                                                        case .failure:
                                                            break
                                                        }
        }
    }
    
    func setPreviousFavoriteButtonState() {
        self.likedButton.isSelected = defaultLikedStatus
    }
    
    // MARK: - Actions
    @IBAction private func likeAction(sender: UIButton) {
        favoriteButtonHandler?(!sender.isSelected)
        sender.isSelected.toggle()
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
