//
//  OrderDetailsCommentCell.swift
//  Pharmacy
//
//  Created by Mikhail Timoscenko on 03.11.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

class OrderDetailsCommentCell: UITableViewCell {

    @IBOutlet weak var corneredView: UIView!
    @IBOutlet weak var commentLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        corneredView.dropLightBlueShadow()
    }

    func apply(comment: String?) {
        commentLabel.text = comment
    }

}
