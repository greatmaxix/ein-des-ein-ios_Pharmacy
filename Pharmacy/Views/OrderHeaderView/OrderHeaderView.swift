//
//  OrderHeaderView.swift
//  Pharmacy
//
//  Created by CGI-Kite on 01.09.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

final class OrderHeaderView: UICollectionReusableView {

    @IBOutlet private weak var titleLable: UILabel!
    @IBOutlet private weak var editButton: UIButton!
    
    var editClosure: EmptyClosure?
    
    override func awakeFromNib() {
        //
    }
    
    @IBAction private func edit(_ sender: UIButton) {
        editClosure?()
    }
    
}
