//
//  SignUpViewController.swift
//  Pharmacy
//
//  Created by Mikhail Timoscenko on 16.06.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var nameInputView: TextInputView!
    @IBOutlet weak var phoneInputView: TextInputView!
    @IBOutlet weak var emailInputView: TextInputView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var socialNetworksLabel: UILabel!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var applyButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupLocalization()
    }
    
    // MARK: - Actions
    
    @IBAction func apply(_ sender: UIButton) {
    }
    
    @IBAction func skipSignUp(_ sender: UIButton) {
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        
        navigationController?.isNavigationBarHidden = true
        nameInputView.contentType = .name
        phoneInputView.contentType = .phone
        emailInputView.contentType = .email
    }
    
    private func setupLocalization() {
        
        titleLabel.text = R.string.localize.loginTitle()
        descriptionLabel.text = R.string.localize.loginDescription()
        socialNetworksLabel.text = R.string.localize.loginSocial()
        skipButton.setTitle(R.string.localize.loginSkip(), for: .normal)
        applyButton.setTitle(R.string.localize.loginApply(), for: .normal)
    }
            
}
