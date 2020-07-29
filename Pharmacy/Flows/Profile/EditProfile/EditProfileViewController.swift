//
//  EditProfileViewController.swift
//  Pharmacy
//
//  Created by CGI-Kite on 29.07.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {

    @IBOutlet private weak var headerView: UIView!
    @IBOutlet private weak var titleLable: UILabel!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var saveButton: UIButton!

    @IBOutlet private weak var userImageView: UIImageView!
    @IBOutlet private weak var nameInputView: TextInputView!
    @IBOutlet private weak var phoneInputView: TextInputView!
    @IBOutlet private weak var emailInputView: TextInputView!

    var model: EditProfileInput!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupLocalization()
    }

    func setupUI() {
        
        nameInputView.contentType = .name
        phoneInputView.contentType = .phone
        emailInputView.contentType = .email
        
        headerView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        headerView.layer.cornerRadius = 10
        
        navigationController?.isNavigationBarHidden = true
        userImageView.layer.cornerRadius = userImageView.bounds.height / 2
    }
    
    func setupLocalization() {
        titleLable.text = R.string.localize.profileEdit()
        backButton.setTitle(R.string.localize.profileProfile(), for: .normal)
        saveButton.setTitle(R.string.localize.profileSaveChanges(), for: .normal)
    }

    @IBAction private func close() {
        
    }
    
    @IBAction private func saveChanges() {
        if phoneInputView.validate() && emailInputView.validate() && nameInputView.validate() {
            
        }
    }
    
    @IBAction private func editImage() {
        
    }
    
}

extension EditProfileViewController: EditProfileOutput {
    
}
