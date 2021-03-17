//
//  ProfileOptionsCell.swift
//  Pharmacy
//
//  Created by CGI-Kite on 13.07.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit
import EventsTree

class ProfileOptionsCellData: BaseCellData {
    override var nibName: String? {
        "ProfileOptionsCell"
    }
        
    override var cellHeight: CGFloat {
         90.0
    }
    
    var events: [ProfileEvent] = []
    var openProfileOption: ((_: ProfileEvent) -> Void)?
}

class ProfileOptionsCell: BaseTableViewCell {

    @IBOutlet private var optionImageViews: [UIImageView]!
    @IBOutlet private var optionLabels: [UILabel]!
    @IBOutlet private weak var roundedView: UIView!
        
    private var openProfileOption: ((_: ProfileEvent) -> Void)?
    private var events: [ProfileEvent] = []

    override func awakeFromNib() {
        super.awakeFromNib()
        
        roundedView.layer.cornerRadius = 12
        selectionStyle = .none
        optionImageViews.forEach({$0.layer.cornerRadius = 8})
        setLocalize()
        dropBlueShadow()
    }
    
    private func setLocalize() {
        optionLabels[0].text = R.string.localize.profileSelected.localized()
        optionLabels[1].text = R.string.localize.profileOrders.localized()
        optionLabels[2].text = R.string.localize.profileAnalize.localized()
        optionLabels[3].text = R.string.localize.profileReceipes.localized()
    }
    
    override func setup(cellData: BaseCellData) {
        if let cd: ProfileOptionsCellData = cellData as? ProfileOptionsCellData {
            openProfileOption = cd.openProfileOption
            events = cd.events
        }
        setLocalize()
    }
    
    @IBAction func selectOption(sender: UIButton) {
        if events.count > sender.tag {
            openProfileOption?(events[sender.tag])
        }
    }
}
