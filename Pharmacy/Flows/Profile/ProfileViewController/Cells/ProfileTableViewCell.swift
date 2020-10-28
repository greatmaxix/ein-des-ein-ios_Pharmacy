//
//  ProfileTableViewCell.swift
//  testProjs7472
//
//  Created by CGI-Kite on 23.06.2020.
//  Copyright © 2020 none. All rights reserved.
//

import UIKit

class ProfileTableViewCellData: BaseCellData {
    
    var title: String
    var additionalInfo: String?
    var image: UIImage?
    var style: ProfileTableViewCell.VisualStyle = .base
    
    override var nibName: String? {
         String(describing: ProfileTableViewCell.self)
    }
    
    override var cellHeight: CGFloat {
         61
    }
    
    init(title: String, additionalInfo: String? = nil, type: ProfileTableViewCell.VisualStyle = .base) {
        self.title = title
        self.additionalInfo = additionalInfo
        self.style = type
    }
}

class ProfileTableViewCell: BaseTableViewCell {
    
    enum VisualStyle {
        case base
        case exit
        case payment
        case region
    }
    
    @IBOutlet private weak var typeImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var additionaInfoLabel: UILabel!
    @IBOutlet private weak var arrowView: UIView!
    @IBOutlet private weak var contentBackgroundView: UIView!
    
    var style: VisualStyle = .base

    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        contentBackgroundView.layer.cornerRadius = 8
        contentBackgroundView.cellLightBlueShadow()
    }
    
    override func setup(cellData: BaseCellData) {
        
        if let cd: ProfileTableViewCellData = cellData as? ProfileTableViewCellData {
            
            titleLabel.text = cd.title
            additionaInfoLabel.text = cd.additionalInfo
            style = cd.style
            typeImageView.image = cd.image
            setupUI()
        }
        
    }
    
    func setupUI() {
        
        typeImageView.layer.cornerRadius = 6
        
        switch style {
        case .base:
            additionaInfoLabel.isHidden = true
            titleLabel.textColor = R.color.textDarkBlue()
            arrowView.isHidden = false
        case .exit:
            arrowView.isHidden = true
            additionaInfoLabel.isHidden = true
            titleLabel.textColor = .red
            typeImageView.tintColor = .red
        case .payment, .region:
            titleLabel.textColor = R.color.textDarkBlue()
            arrowView.isHidden = false
            additionaInfoLabel.isHidden = false
        }
    }
}
