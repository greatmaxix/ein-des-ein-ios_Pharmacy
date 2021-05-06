//
//  CallCell.swift
//  Pharmacy
//
//  Created by Anna Yatsun on 06.05.2021.
//  Copyright © 2021 pharmacy. All rights reserved.
//

import UIKit

class CallCell: UITableViewCell {

    
    @IBOutlet var callToUsView: UIView?
    
    @IBOutlet var callAssLabel: UILabel!
    @IBOutlet var questionLabel: UILabel!
    
    
    func fill() {
        self.configUI()
    }
    
    private func configUI() {
        callToUsView?.backgroundColor = UIColor(red: 0, green: 0.039, blue: 0.387, alpha: 1)
        callToUsView?.layer.cornerRadius = 8
        self.callAssLabel.text = R.string.localize.call_to_uss.localized()
        self.questionLabel.text = R.string.localize.still_questions.localized()
    }
}
