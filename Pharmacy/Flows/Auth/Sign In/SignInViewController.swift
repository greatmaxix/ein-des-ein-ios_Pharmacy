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

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var phoneInputView: TextInputView!
    @IBOutlet private weak var scrollView: UIScrollView!
    
    @IBOutlet private weak var applyButton: UIButton!
    @IBOutlet private weak var registerButton: UIButton!
    @IBOutlet private weak var accountLabel: UILabel!
    @IBOutlet private weak var enterLabel: UILabel!
    @IBOutlet private weak var skipButton: UIButton!
    @IBOutlet private weak var logoTopConstraint: NSLayoutConstraint!
    
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
    }
    
    func setupLocalization() {
        
        titleLabel.text = R.string.localize.loginTitle()
        descriptionLabel.text = R.string.localize.loginDescription()
        registerButton.setTitle(R.string.localize.loginSignup(), for: .normal)
        enterLabel.text = R.string.localize.loginEnter()
        accountLabel.text = R.string.localize.loginAccount()
        skipButton.setTitle(R.string.localize.signupSkip(), for: .normal)
    }
    
    func setupUI() {
        
        phoneInputView.contentType = .phone
        applyButton.layer.cornerRadius = applyButton.frame.height / 2
        applyButton.imageView?.contentMode = .scaleToFill
        
        let screenHeight = UIScreen.main.bounds.height
        let heightCoef = (screenHeight - Const.minScreenHeight) / (Const.maxScreenHeight - Const.minScreenHeight)
        logoTopConstraint.constant = heightCoef * Const.maxLogoTopSpace + (1 - heightCoef) * Const.minLogoTopSpace
    }
    
    // MARK: - Actions
    
    @IBAction func apply(_ sender: UIButton) {
        if let phone: String = phoneInputView.text, phoneInputView.validate() {
            model.signIn(phone: phone)
            sender.isUserInteractionEnabled = false
            enterLabel.textColor = R.color.textDarkBlue()
        }
    }
    
    @IBAction func createAccount(_ sender: UIButton) {
        model.signUp()
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
        
        enterLabel.textColor = phoneInputView.validate() ? R.color.textDarkBlue() : R.color.applyBlueGray()

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
        showError(message: message)
    }
}

// MARK: - Const

fileprivate extension SignInViewController {
    struct Const {
        static let minLogoTopSpace: CGFloat = 36
        static let maxLogoTopSpace: CGFloat = 158
        static let minScreenHeight: CGFloat = 550
        static let maxScreenHeight: CGFloat = 896
    }
}

//MARK:- extension for SimpleNavigationBarDelegate
extension SignInViewController : SimpleNavigationBarDelegate {
    func leftBarItemAction() {
        model.back()
    }
    
    func rightBarItemAction() {
        //
    }
}
