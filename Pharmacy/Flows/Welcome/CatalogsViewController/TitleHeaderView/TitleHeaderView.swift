//
//  TitleHeaderView.swift
//  Pharmacy
//
//  Created by CGI-Kite on 29.07.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

class TitleHeaderView: UIView {

    @IBOutlet private weak var titleLabel: UILabel!
    
    private let heightWithTitle: CGFloat = 60
    private let heightWithoutTitle: CGFloat = 30
    
    var title: String? {
        willSet {
            titleLabel.text = newValue
            let height: CGFloat = newValue == nil ? heightWithoutTitle : heightWithTitle
            frame = CGRect(origin: frame.origin, size: CGSize(width: frame.width, height: height))
        }
    }
}
