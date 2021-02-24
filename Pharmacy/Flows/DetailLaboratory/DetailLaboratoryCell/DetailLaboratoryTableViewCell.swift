//
//  DetailLaboratoryTableViewCell.swift
//  Pharmacy
//
//  Created by Anna Yatsun on 19.02.2021.
//  Copyright © 2021 pharmacy. All rights reserved.
//

import UIKit

class DetailLaboratoryTableViewCell: UITableViewCell {

    @IBOutlet private var conteinerView: UIView!
    @IBOutlet private var nameLaboratoryLabel: UILabel!
    @IBOutlet private var countOfDayLabel: UILabel!
    
    func apply(deteilLaboratory: LaboratoryDetailModel) {
        self.nameLaboratoryLabel.text = deteilLaboratory.analisName
        deteilLaboratory.countOfDay.map {
            self.countOfDayLabel.text = $0 + "ДНЕ"
        }
        self.conteinerView.layer.cornerRadius = 10
    }
}
    
