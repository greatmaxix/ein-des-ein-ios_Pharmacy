//
//  NavigationBarWithSearchView.swift
//  Pharmacy
//
//  Created by Anna Yatsun on 17.02.2021.
//  Copyright © 2021 pharmacy. All rights reserved.
//

import UIKit

class NavigationBarWithSearchView: UIView, NibView {


    @IBOutlet var searchView: UIView?
    @IBOutlet var serchInfoPlaceholderlabel: UITextField?
    
    // MARK: - Init / Deinit Methods
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadViewFromNib()


    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        loadViewFromNib()
        self.searchView?.backgroundColor = UIColor(displayP3Red: 255, green: 255, blue: 255, alpha: 0.3)
        self.searchView?.layer.cornerRadius = 12
        self.serchInfoPlaceholderlabel?.placeholder = "Какие исследования вы ищите?"
        
    }
}
