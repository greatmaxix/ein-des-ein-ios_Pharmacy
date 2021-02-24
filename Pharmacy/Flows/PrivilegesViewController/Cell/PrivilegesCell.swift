//
//  PrivilegesCell.swift
//  Pharmacy
//
//  Created by Anna Yatsun on 24.02.2021.
//  Copyright © 2021 pharmacy. All rights reserved.
//

import UIKit

class PrivilegesCell: UITableViewCell {
    
    @IBOutlet var name: UILabel!
    @IBOutlet var conteinerView: UIView!
    func apply(name: String) {
        self.name.text = name
        self.configure()
    }
    
    func configure() {
        self.conteinerView.layer.cornerRadius = 12
    }
}
