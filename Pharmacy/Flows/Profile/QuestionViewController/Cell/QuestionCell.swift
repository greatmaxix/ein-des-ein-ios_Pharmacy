//
//  QuestionCell.swift
//  Pharmacy
//
//  Created by Anna Yatsun on 09.03.2021.
//  Copyright © 2021 pharmacy. All rights reserved.
//

import UIKit

enum QustionCellType {
    case selected
    case openInfo
}

struct QustionModel {
    let image: String
    let name: String
    let type: QustionCellType
}

class QuestionCell: BaseCell<QustionModel, QustionCellType> {

    @IBOutlet var conteinerView: UIView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var questionImageiew: UIImageView!
    
    @IBOutlet var informAboutType: UIView!
    
    func apply(model: QustionModel, isHidden: Bool) {
        questionImageiew.image = UIImage(named: model.image)
        nameLabel.text = model.name
        conteinerView.layer.cornerRadius = 8
        informAboutType.isHidden = isHidden
    }
}
