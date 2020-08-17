//
//  EditProfileViewController.swift
//  Pharmacy
//
//  Created by CGI-Kite on 29.07.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

protocol EditProfileOutput: class {
}

final class EditProfileViewController: UIViewController {

    @IBOutlet private weak var headerView: UIView!
    @IBOutlet private weak var titleLable: UILabel!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var saveButton: UIButton!
    @IBOutlet private weak var editPhotoButton: UIButton!

    @IBOutlet private weak var userImageView: UIImageView!
    @IBOutlet private weak var nameInputView: TextInputView!
    @IBOutlet private weak var phoneInputView: TextInputView!
    @IBOutlet private weak var emailInputView: TextInputView!
    
    private var tapGesture: UITapGestureRecognizer!
    private var imagePicker: UIImagePickerController = UIImagePickerController()
    
    var model: EditProfileInput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLocalization()
        
        imagePicker.delegate = self
    }

    private func setupUI() {
        
        nameInputView.contentType = .name
        phoneInputView.contentType = .phone
        emailInputView.contentType = .email
        
        if let user = model.getUser() {
            nameInputView.placeholder = user.name
            phoneInputView.placeholder = user.phone
            phoneInputView.needsCountryCode = false
            emailInputView.placeholder = user.email
        }
        
        headerView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        headerView.layer.cornerRadius = 10
        
        navigationController?.isNavigationBarHidden = true
        userImageView.layer.cornerRadius = userImageView.bounds.height / 2
        editPhotoButton.layer.cornerRadius = editPhotoButton.bounds.height / 2
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(endTextfieldEditing))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupLocalization() {
        titleLable.text = R.string.localize.profileEdit()
        backButton.setTitle(R.string.localize.profileProfile(), for: .normal)
        saveButton.setTitle(R.string.localize.profileSaveChanges(), for: .normal)
    }

    @IBAction private func close() {
        model.close()
    }
    
    @IBAction private func saveChanges() {
        
        var validationSuccess = phoneInputView.validate()
        validationSuccess = emailInputView.validate() && validationSuccess
        validationSuccess = nameInputView.validate() && validationSuccess
        if validationSuccess, let name: String = nameInputView.text, let email: String = emailInputView.text, let phone: String = phoneInputView.text {
            model.saveProfile(name: name, phone: phone, email: email)
        }
    }
    
    @IBAction private func editImage() {
        
        let alertVC = UIAlertController(title: R.string.localize.profileMakePhoto(), message: R.string.localize.profileMakePhotoDescription(), preferredStyle: .alert)
        
        alertVC.addAction(UIAlertAction(title: R.string.localize.profileCamera(), style: .default, handler: { [weak self] _ in
            self?.openCamera()
        }))
        alertVC.addAction(UIAlertAction(title: R.string.localize.profileGalery(), style: .default, handler: { [weak self] _ in
            self?.openPhotoLibrary()
        }))
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))

        present(alertVC, animated: true, completion: nil)
    }
    
    private func openPhotoLibrary() {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func openCamera() {
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc private func endTextfieldEditing() {
        phoneInputView.endEditing(true)
        emailInputView.endEditing(true)
        nameInputView.endEditing(true)
    }
}

extension EditProfileViewController: EditProfileOutput {
    
}

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        if let image: UIImage = info[.originalImage] as? UIImage {
            model.saveImage(image: image)
            userImageView.image = image.bluredImage(sigma: 10)
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
