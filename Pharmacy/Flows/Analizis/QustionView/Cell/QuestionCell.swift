//
//  QuestionCell.swift
//  Pharmacy
//
//  Created by Anna Yatsun on 09.03.2021.
//  Copyright © 2021 pharmacy. All rights reserved.
//

import UIKit

struct QustionModel: Codable {
    let image: String
    let name: String
    
}

class QuestionCell: UITableViewCell {

    @IBOutlet var conteinerView: UIView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var questionImageiew: UIImageView!
    
    func apply(model: QustionModel) {
        self.questionImageiew.image = UIImage(named: model.image)
        self.nameLabel.text = model.name
        self.conteinerView.layer.cornerRadius = 8
    }
    
}
