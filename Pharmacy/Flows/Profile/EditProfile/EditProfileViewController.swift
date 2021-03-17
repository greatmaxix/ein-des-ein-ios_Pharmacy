//
//  EditProfileViewController.swift
//  Pharmacy
//
//  Created by CGI-Kite on 29.07.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit
import MBProgressHUD

final class EditProfileViewController: UIViewController, SimpleNavigationBarDelegate {

    @IBOutlet private weak var editPhotoButton: UIButton!

    @IBOutlet private weak var userImageView: UIImageView!
    @IBOutlet private weak var nameInputView: TextInputView!
    @IBOutlet private weak var phoneInputView: TextInputView!
    @IBOutlet private weak var emailInputView: TextInputView!
    
    private var tapGesture: UITapGestureRecognizer!
    private var activityIndicator: MBProgressHUD!
    private var imagePicker: UIImagePickerController = UIImagePickerController()
    
    var model: EditProfileInput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        activityIndicator = setupActivityIndicator()
        setupLocalization()
        
        imagePicker.delegate = self
    }

    private func setupUI() {
        
        nameInputView.contentType = .name
        emailInputView.contentType = .email
        
        nameInputView.placeholder = model.name
        emailInputView.placeholder = model.email

        setInputText()

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
            bar.title = R.string.localize.profileEdit.localized()
            bar.leftItemTitle = R.string.localize.profileProfile.localized()
            bar.rightItemTitle = R.string.localize.profileSaveChanges.localized()
            bar.barDelegate = self
        }
    }
    
    @IBAction private func editImage() {
        
        let alertVC = UIAlertController(title: R.string.localize.profileMakePhoto.localized(), message: R.string.localize.profileMakePhotoDescription.localized(), preferredStyle: .alert)
        
        alertVC.addAction(UIAlertAction(title: R.string.localize.profileCamera.localized(), style: .default, handler: { [weak self] _ in
            self?.openCamera()
        }))
        alertVC.addAction(UIAlertAction(title: R.string.localize.profileGalery.localized(), style: .default, handler: { [weak self] _ in
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
        imagePicker.cameraCaptureMode = .photo

        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc private func endTextfieldEditing() {
        emailInputView.endEditing(true)
        nameInputView.endEditing(true)
    }
  
    func setInputText() {
        if nameInputView.text == "" {
            nameInputView.text = model.name
        }
        if phoneInputView.text == "" {
            phoneInputView.text = "+\(model.phone.dropFirst(0).prefix(2)) (\(model.phone.dropFirst(2).prefix(3))) \(model.phone.dropFirst(5).prefix(3))-\(model.phone.dropFirst(8).prefix(4))"
        }
        if emailInputView.text == "" {
            emailInputView.text = model.email
        }
    }
    
    func leftBarItemAction() {
        model.close()
    }
    
    func rightBarItemAction() {
      
        let validationSuccess = nameInputView.validate()

        if validationSuccess,
           let name: String = nameInputView.text,
           let email: String = emailInputView.text,
           let _: String = phoneInputView.text {
            self.activityIndicator.show(animated: true)
            let checkedEmail = !email.isEmpty && emailInputView.validate() ? email : ""
            model.saveProfile(name: name, email: checkedEmail)
        }
    }
}

extension EditProfileViewController: EditProfileOutput {

    func savingImageSuccess() {
        disableHUD()
    }
}

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        if let image: UIImage = info[.originalImage] as? UIImage {
        
            var mime: String = "image/"

            if let url: URL = info[.imageURL] as? URL {
                mime += url.lastPathComponent.components(separatedBy: ".").last ?? ""
                model.saveImage(image: image, mime: mime, fileName: url.lastPathComponent)
                
                let blurredImage: UIImage = image.bluredImage(sigma: 5) ?? image
                userImageView.image = blurredImage
                enableHUD()
            } else {
                let identifier = UUID()
                let fixedOrientationImage = image.fixedOrientation()
                
                model.saveImage(image: fixedOrientationImage, mime: "image/.png", fileName: identifier.uuidString)
                userImageView.image = fixedOrientationImage
                enableHUD()
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    private func disableHUD() {
        activityIndicator.hide(animated: true)
    }
    private func enableHUD() {
        activityIndicator.show(animated: true)
    }
}
