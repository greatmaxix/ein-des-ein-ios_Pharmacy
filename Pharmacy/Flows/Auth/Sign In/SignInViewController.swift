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
        setupTargets()
        KeychainManager.shared.saveToken(token: "")
    }
    
    func setupLocalization() {
        
        titleLabel.text = R.string.localize.loginTitle.localized()
        descriptionLabel.text = R.string.localize.loginDescription.localized()
        registerButton.setTitle(R.string.localize.loginSignup.localized(), for: .normal)
        enterLabel.text = R.string.localize.loginEnter.localized()
        accountLabel.text = R.string.localize.loginAccount.localized()
        skipButton.setTitle(R.string.localize.signupSkip.localized(), for: .normal)
    }
    
    func setupUI() {
        phoneInputView.contentType = .phone
        applyButton.layer.cornerRadius = applyButton.frame.height / 2
        applyButton.imageView?.contentMode = .scaleToFill
        
        let screenHeight = UIScreen.main.bounds.height
        let heightCoef = (screenHeight - Const.minScreenHeight) / (Const.maxScreenHeight - Const.minScreenHeight)
        logoTopConstraint.constant = heightCoef * Const.maxLogoTopSpace + (1 - heightCoef) * Const.minLogoTopSpace
    }
    
    private func setupTargets() {
        phoneInputView.addTextFieldTarget(self, action: #selector(manageSignInButton), for: .editingChanged)
    }
    
    @objc private func manageSignInButton() {
        guard phoneInputView.validate() else {
            disableSignInButton()
            return
        }

        enableSignInButton()
    }
    
    private func enableSignInButton() {
        enterLabel.textColor = R.color.textDarkBlue()
        applyButton.backgroundColor = R.color.welcomeBlue()
        applyButton.isUserInteractionEnabled = true
    }
    
    private func disableSignInButton() {
        enterLabel.textColor = R.color.applyBlueGray()
        applyButton.backgroundColor = R.color.applyBlueGray()
        applyButton.isUserInteractionEnabled = false
    }
    
    // MARK: - Actions
    
    @IBAction func apply(_ sender: UIButton) {
        guard let phone = self.phoneInputView.text, phoneInputView.validate() else {
            return
        }
        self.model.signIn(phone: phone)
    }
    
    @IBAction func createAccount(_ sender: UIButton) {
        model.signUp()
    }
    
    @IBAction func skipSignIn(_ sender: UIButton) {
        skipRegistrationAlertViewController()
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
            self.enterLabel.textColor = phoneInputView.validate() ? R.color.textDarkBlue() : R.color.applyBlueGray()

        scrollView.contentInset = scrollViewInsets
        phoneInputView.endEditing(true)
    }
    
    // MARK: - Alert ViewController to skip registration
    private func skipRegistrationAlertViewController() {
        
        let blurEffect = UIBlurEffect(style: .light)
        let blurVisualEffectView = UIVisualEffectView(effect: blurEffect)
        blurVisualEffectView.frame = view.bounds
        
        let alertController = UIAlertController.init(title: R.string.localize.signupAlert_title.localized(), message: R.string.localize.signupAlert_body.localized(), preferredStyle: .alert)

        let actionOK = UIAlertAction(title: R.string.localize.signupAlert_ok.localized(), style: .default, handler: { _ in blurVisualEffectView.removeFromSuperview()})

        let actionCancel = UIAlertAction(title: R.string.localize.signupAlert_cancel.localized(), style: .default, handler: {[unowned self] _ in
            self.model.startMainFlowWithOutRegistration()
            blurVisualEffectView.removeFromSuperview()
        })

        alertController.addAction(actionOK)
        alertController.addAction(actionCancel)
        alertController.preferredAction = actionCancel
        self.view.addSubview(blurVisualEffectView)
        self.present(alertController, animated: true, completion: nil)
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
        enableSignInButton()
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

// MARK: - extension for SimpleNavigationBarDelegate
extension SignInViewController: SimpleNavigationBarDelegate {
    func leftBarItemAction() {
        model.back()
    }
    
    func rightBarItemAction() {}
}
