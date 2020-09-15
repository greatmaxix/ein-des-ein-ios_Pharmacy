//
//  EmptySearchView.swift
//  Pharmacy
//
//  Created by Sapa Denys on 15.09.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

class EmptySearchView: UIView, NibView {

    // MARK: - Outlets
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    // MARK: - Init / Deinit Methods
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadViewFromNib()
        initialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        loadViewFromNib()
        initialize()
    }
}

extension EmptySearchView {
    
    private func initialize() {
        titleLabel.text = R.string.localize.searchEmptyStateTitle()
        descriptionLabel.text = R.string.localize.searchEmptyStateDescription()
    }
}
