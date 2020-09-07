//
//  RegionCell.swift
//  Pharmacy
//
//  Created by CGI-Kite on 04.09.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

class RegionCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var selectImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        selectImageView.isHidden = !selected
        titleLabel.font = selected ? R.font.openSansBold(size: 16) : R.font.openSansRegular(size: 16)
    }
    
    func apply(region: Region) {
        titleLabel.text = region.name
    }
}
