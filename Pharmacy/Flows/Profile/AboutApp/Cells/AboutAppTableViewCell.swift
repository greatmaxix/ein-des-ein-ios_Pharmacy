//
//  AboutAppTableViewCell.swift
//  Pharmacy
//
//  Created by Ekateryna Maslova on 28.10.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

class AboutAppTableViewCellData: BaseCellData {
  
  var title: String
  var additionalInfo: String?
  var image: UIImage?
  
  override var nibName: String? {
    String(describing: AboutAppTableViewCell.self)
  }
  
  override var cellHeight: CGFloat {
    61
  }
  
  init(title: String, additionalInfo: String? = nil) {
    self.title = title
    self.additionalInfo = additionalInfo
  }
}

class AboutAppTableViewCell: BaseTableViewCell {
  
  // MARK: - Outlets
  @IBOutlet private weak var typeImageView: UIImageView!
  @IBOutlet private weak var titleLabel: UILabel!
  @IBOutlet private weak var additionaInfoLabel: UILabel!
  @IBOutlet private weak var arrowView: UIView!
  @IBOutlet private weak var contentBackgroundView: UIView!
  
  // MARK: - Lifecycle
  override func awakeFromNib() {
    super.awakeFromNib()
    
    selectionStyle = .none
    contentBackgroundView.layer.cornerRadius = 8
    contentBackgroundView.cellLightBlueShadow()
  }
  
  override func setup(cellData: BaseCellData) {
    if let cd: AboutAppTableViewCellData = cellData as? AboutAppTableViewCellData {
      
      titleLabel.text = cd.title
      additionaInfoLabel.text = cd.additionalInfo
      typeImageView.image = cd.image
      setupUI()
    }
  }
  
  private func setupUI() {
    
    typeImageView.layer.cornerRadius = 6
    additionaInfoLabel.isHidden = true
    titleLabel.textColor = R.color.textDarkBlue()
    arrowView.isHidden = false
  }
}
