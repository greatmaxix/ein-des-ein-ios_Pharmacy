//
//  TypeOfAnalysisCell.swift
//  Pharmacy
//
//  Created by Anna Yatsun on 18.02.2021.
//  Copyright © 2021 pharmacy. All rights reserved.
//

import UIKit

enum TypeOfAnalysisCellEvent {
    
}

class TypeOfAnalysisCell: BaseCell<TypeOfAnalysis, TypeOfAnalysisCellEvent> {

    @IBOutlet private var whiteCotentView: UIView?
    @IBOutlet private var nameOfTypeAnalysis: UILabel?
    
    func apply(analisName: TypeOfAnalysis) {
        self.whiteCotentView?.layer.cornerRadius = 10
        self.nameOfTypeAnalysis?.text = analisName.analisName
    }
    
    override func fill(with model: TypeOfAnalysis) {
        super.fill(with: model)
        apply(analisName: model)
    }
}
