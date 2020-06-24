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
    var style: ProfileTableViewCell.VisualStyle = .base
    
    override var nibName: String? {
        return String(describing: ProfileTableViewCell.self)
    }
    
    override var cellHeight: CGFloat {
        return 44
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
        case paiment
        case region
    }
    
    @IBOutlet weak var typeImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var additionaInfoLabel: UILabel!
    @IBOutlet weak var arrowView: UIView!
    
    var style: VisualStyle = .base

    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    override func setup(cellData: BaseCellData) {
        
        if let cd: ProfileTableViewCellData = cellData as? ProfileTableViewCellData {
            
            titleLabel.text = cd.title
            additionaInfoLabel.text = cd.additionalInfo
            style = cd.style
            setupUI()
        }
    }
    
    func setupUI() {
        
        typeImageView.layer.cornerRadius = 6
        
        switch style {
        case .base:
            additionaInfoLabel.isHidden = true
        case .exit:
            arrowView.isHidden = true
            additionaInfoLabel.isHidden = true
        case .paiment:
            break
        case .region:
            arrowView.isHidden = true
            additionaInfoLabel.textColor = .blue
        }
    }
}
