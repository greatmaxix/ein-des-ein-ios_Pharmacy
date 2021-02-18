//
//  TypeOfAnalysisCell.swift
//  Pharmacy
//
//  Created by Anna Yatsun on 18.02.2021.
//  Copyright © 2021 pharmacy. All rights reserved.
//

import UIKit

class TypeOfAnalysisCell: UITableViewCell {

    @IBOutlet var whiteCotentView: UIView?
    @IBOutlet var nameOfTypeAnalysis: UILabel?
    
    func apply(analisName: TypeOfAnalysis) {
        self.whiteCotentView?.layer.cornerRadius = 10
        self.nameOfTypeAnalysis?.text = analisName.analisName
    }
}
