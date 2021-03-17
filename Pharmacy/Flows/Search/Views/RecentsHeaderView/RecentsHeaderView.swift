//
//  RecentsHeaderView.swift
//  Pharmacy
//
//  Created by Sapa Denys on 17.09.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

final class RecentsHeaderView: UITableViewHeaderFooterView {

    // MARK: - Outlets
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var clearButton: UIButton!
    
    // MARK: - Properties
    var clearActionHandler: (() -> Void)?
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }
}

// MARK: - Actions
extension RecentsHeaderView {
    
    @IBAction private func onClearButtonTouchUp(_ sender: UIButton) {
        clearActionHandler?()
    }
}

// MARK: - Private methods
extension RecentsHeaderView {
    
    private func setupView() {
        titleLabel.text = R.string.localize.searchRecentsHeader.localized()
        clearButton.setTitle(R.string.localize.actionClean.localized(),
                             for: .normal)
    }
}

extension RecentsHeaderView: NibReusable {}
