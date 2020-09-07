//
//  SuccessfulSignUpViewController.swift
//  Pharmacy
//
//  Created by Sapa Denys on 07.09.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

class SuccessfulSignUpViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    // MARK: - Properties
    var model: SuccessfulSignUpModelInput!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = R.string.localize.confirmScreenTitle()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        model.onViewDidApearAction()
    }
}

// MARK: - Private methods
extension SuccessfulSignUpViewController {
    
    private func setupView() {
        titleLabel.text = R.string.localize.successfulLoginTitle()
        descriptionLabel.text = R.string.localize.successfulLoginDescription()
    }
}
