//
//  LanguageTableViewCell.swift
//  Pharmacy
//
//  Created by Anna Yatsun on 10.03.2021.
//  Copyright © 2021 pharmacy. All rights reserved.
//

import UIKit

class LanguageTableViewCell: UITableViewCell {

    @IBOutlet private var languageImageView: UIImageView!
    @IBOutlet private var languageName: UILabel!
    @IBOutlet private var whiteCotentView: UIView?
    
    func apply(languageModel: LanguageModel, selected: Bool) {
        self.languageImageView.isHidden = !selected
        self.languageName.text = languageModel.name
        self.whiteCotentView?.layer.cornerRadius = 10
    }
}
