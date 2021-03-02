//
//  InformationHeaderView.swift
//  Pharmacy
//
//  Created by Anna Yatsun on 02.03.2021.
//  Copyright © 2021 pharmacy. All rights reserved.
//

import UIKit

class InformationHeaderView: UIView {

    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var showAllButton: UIButton!
    
    private var action: () -> Void = { }
    
    @IBAction func showAllAction(_ sender: Any) {
        action()
    }
    
    func configure(title: String, action: @escaping () -> Void) {
        textLabel.text = title
        self.action = action
    }
}
