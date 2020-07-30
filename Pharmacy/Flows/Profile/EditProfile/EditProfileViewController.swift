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
    @IBOutlet private weak var editPhotoButton: UIButton!

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

    private func setupUI() {
        
        nameInputView.contentType = .name
        phoneInputView.contentType = .phone
        emailInputView.contentType = .email
        
        headerView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        headerView.layer.cornerRadius = 10
        
        navigationController?.isNavigationBarHidden = true
        userImageView.layer.cornerRadius = userImageView.bounds.height / 2
        editPhotoButton.layer.cornerRadius = editPhotoButton.bounds.height / 2
        setBlur()
    }

    func setBlur() {
        if let image = R.image.confirmIcon(), var ciImage = CIImage(image: image) {

            ciImage = ciImage.applyingGaussianBlur(sigma: 5)
            let extent = ciImage.extent
            let space = abs(ciImage.extent.origin.x)
            let rect = CGRect(x: 0, y: 0, width: extent.width - space * 2, height: extent.height - space * 2)
            let croppedImage = ciImage.cropped(to: rect)
            // swiftlint:disable all
            let blurredImage = UIImage(ciImage: croppedImage)
            userImageView.image = blurredImage
        }
    }
    
    private func setupLocalization() {
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
