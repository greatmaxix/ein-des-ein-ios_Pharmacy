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

final class EditProfileViewController: UIViewController, SimpleNavigationBarDelegate {

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
        
        nameInputView.placeholder = model.name
        phoneInputView.placeholder = model.phone
        phoneInputView.needsCountryCode = false
        emailInputView.placeholder = model.email
        
        if let url: URL = model.imageUrl {
            userImageView.loadImageBy(url: url, completion: { [weak self] _ in
                let image: UIImage? = self?.userImageView.image
                self?.userImageView.image = image?.bluredImage(sigma: 5)
            })
        }
        
        userImageView.layer.cornerRadius = userImageView.bounds.height / 2
        editPhotoButton.layer.cornerRadius = editPhotoButton.bounds.height / 2
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(endTextfieldEditing))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupLocalization() {
        if let bar = navigationController?.navigationBar as? SimpleNavigationBar {
            
            bar.isLeftItemHidden = false
            bar.isRightItemHidden = false
            bar.title = R.string.localize.profileEdit()
            bar.leftItemTitle = R.string.localize.profileProfile()
            bar.rightItemTitle = R.string.localize.profileSaveChanges()
            bar.barDelegate = self
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
    
    func leftBarItemAction() {
        model.close()
    }
    
    func rightBarItemAction() {
        var validationSuccess = phoneInputView.validate()
        validationSuccess = emailInputView.validate() && validationSuccess
        validationSuccess = nameInputView.validate() && validationSuccess
        if validationSuccess, let name: String = nameInputView.text, let email: String = emailInputView.text, let _: String = phoneInputView.text {
            model.saveProfile(name: name, email: email)
        }
    }
}

extension EditProfileViewController: EditProfileOutput {
    
}

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        if let image: UIImage = info[.originalImage] as? UIImage {
            
            var mime: String = "image/"
            let blurredImage: UIImage = image.bluredImage(sigma: 5) ?? image
            if let url: URL = info[.imageURL] as? URL {
                
                mime += url.lastPathComponent.components(separatedBy: ".").last ?? ""
                model.saveImage(image: image, mime: mime, fileName: url.lastPathComponent)
                userImageView.image = blurredImage
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
