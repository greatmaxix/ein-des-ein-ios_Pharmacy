//
//  FilledContactInfoCell.swift
//  Pharmacy
//
//  Created by CGI-Kite on 31.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

final class FilledContactInfoCell: UITableViewCell {
    
    @IBOutlet private weak var nameFilledLabel: UILabel!
    @IBOutlet private weak var phoneFilledLabel: UILabel!
    @IBOutlet private weak var emailFilledLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setup(name: String, email: String, phone: String) {
        nameFilledLabel.text = name
        phoneFilledLabel.text = "📱 " + phone
        emailFilledLabel.text = "📪 " + email
    }
    
}
