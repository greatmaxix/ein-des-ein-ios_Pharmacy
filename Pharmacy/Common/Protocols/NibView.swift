//
//  NibView.swift
//  Pharmacy
//
//  Created by Sapa Denys on 10.09.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

protocol NibView {
    func loadViewFromNib()
}

extension NibView where Self: UIView {
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        if let view = nib.instantiate(withOwner: self, options: nil).first as? UIView {
            view.frame = bounds
            
            view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth,
                                     UIView.AutoresizingMask.flexibleHeight]
            
            addSubview(view)
        }
    }
}
