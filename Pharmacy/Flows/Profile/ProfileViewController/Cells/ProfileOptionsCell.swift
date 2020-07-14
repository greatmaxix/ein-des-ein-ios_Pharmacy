//
//  ProfileOptionsCell.swift
//  Pharmacy
//
//  Created by CGI-Kite on 13.07.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

class ProfileOptionsCellData: BaseCellData {
    override var nibName: String? {
        return "ProfileOptionsCell"
    }
    
    var handlers: [() -> Void] = []
    
    override var cellHeight: CGFloat {
        return 90.0
    }
}

class ProfileOptionsCell: BaseTableViewCell {

    @IBOutlet var optionImageViews: [UIImageView]!
    @IBOutlet var optionLabels: [UILabel]!
    @IBOutlet weak var roundedView: UIView!
    
    private var handlers: [() -> Void] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        roundedView.layer.cornerRadius = 12
        selectionStyle = .none
        optionImageViews.forEach({$0.layer.cornerRadius = 8})
        optionLabels[0].text = R.string.localize.profileSelected()
        optionLabels[1].text = R.string.localize.profileOrders()
        optionLabels[2].text = R.string.localize.profileAnalize()
        optionLabels[3].text = R.string.localize.profileReceipes()
        dropBlueShadow()
    }
    
    override func setup(cellData: BaseCellData) {
        if let cd: ProfileOptionsCellData = cellData as? ProfileOptionsCellData {
            handlers = cd.handlers
        }
    }
    
    @IBAction func selectOption(sender: UIButton) {
        if handlers.count > sender.tag {
            handlers[sender.tag]()
        }
    }
}
