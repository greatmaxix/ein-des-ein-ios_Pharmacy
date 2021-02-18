//
//  LaboratoryTableViewCell.swift
//  Pharmacy
//
//  Created by Anna Yatsun on 18.02.2021.
//  Copyright © 2021 pharmacy. All rights reserved.
//

import UIKit

class LaboratoryTableViewCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel?
    
    func apply(laboratory: LaboratoryResearchModel) {
        self.nameLabel?.text = laboratory.laboratoryName
    }
}
