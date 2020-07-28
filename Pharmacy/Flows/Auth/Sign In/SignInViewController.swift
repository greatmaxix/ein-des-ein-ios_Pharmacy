//
//  SignInViewController.swift
//  Pharmacy
//
//  Created by Mikhail Timoscenko on 16.06.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit
import EventsTree

final class SignInViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var phoneInputView: TextInputView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var socialLabel: UILabel!
    @IBOutlet weak var enterLabel: UILabel!
    @IBOutlet weak var skipButton: UIButton!
    
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var appleButton: UIButton!
    @IBOutlet weak var faceIdButton: UIButton!
    
    private var tapGesture: UITapGestureRecognizer!
    private var scrollViewInsets: UIEdgeInsets!
    var model: SignInInput!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLocalization()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardDidHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        scrollView.addGestureRecognizer(tapGesture)
        scrollViewInsets = scrollView.contentInset
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    func setupLocalization() {
        
        titleLabel.text = R.string.localize.loginTitle()
        descriptionLabel.text = R.string.localize.loginDescription()
        registerButton.setTitle(R.string.localize.loginSignup(), for: .normal)
        enterLabel.text = R.string.localize.loginEnter()
        accountLabel.text = R.string.localize.loginAccount()
        socialLabel.text = R.string.localize.loginSocial()
        skipButton.setTitle(R.string.localize.signupSkip(), for: .normal)
    }
    
    func setupUI() {
        
        phoneInputView.contentType = .phone
        applyButton.layer.cornerRadius = applyButton.frame.height / 2
        applyButton.imageView?.contentMode = .scaleToFill
        
        facebookButton.layer.cornerRadius = faceIdButton.frame.height / 2
        googleButton.layer.cornerRadius = googleButton.frame.height / 2
        appleButton.layer.cornerRadius = appleButton.frame.height / 2
        faceIdButton.layer.cornerRadius = faceIdButton.frame.height / 2
        
        facebookButton.dropBlueShadow()
        googleButton.dropBlueShadow()
        appleButton.dropBlueShadow()
        faceIdButton.dropBlueShadow()
    }
    
    // MARK: - Actions
    
    @IBAction func apply(_ sender: UIButton) {
        
        #if DEBUG
        model.signIn(phone: "380930000005")
        sender.isUserInteractionEnabled = false
        #else
        if let phone: String = phoneInputView.text, phoneInputView.validate() {

            model.signIn(phone: phone)
            sender.isUserInteractionEnabled = false
        }
        #endif
    }
    
    @IBAction func createAccount(_ sender: UIButton) {
        model.signUp()
       // model.openProfile()
    }
    
    // MARK: - Keyboard
    
    @objc private func keyboardWillAppear(notification: NSNotification) {
        
        if let rect: CGRect = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            
            scrollView.contentInset = UIEdgeInsets(top: scrollViewInsets.top, left: scrollViewInsets.left, bottom: scrollViewInsets.bottom + rect.height, right: scrollViewInsets.right)
        }
    }
    
    @objc private func keyboardWillDisappear() {
        
        scrollView.contentInset = scrollViewInsets
    }
    
    @objc private func hideKeyboard() {
        
        scrollView.contentInset = scrollViewInsets
        phoneInputView.endEditing(true)
    }
    
}

// MARK: - UITextFieldDelegate

extension SignInViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        apply(applyButton)
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - UITextFieldDelegate

extension SignInViewController: SignInOutput {
    
    func unblockApplyButton() {
        applyButton.isUserInteractionEnabled = true
    }
    
    func failedToLogin(message: String) {
        showAlertVC(title: message)
    }
}
