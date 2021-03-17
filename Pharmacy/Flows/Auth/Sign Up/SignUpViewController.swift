//
//  SignUpViewController.swift
//  Pharmacy
//
//  Created by Mikhail Timoscenko on 16.06.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

final class SignUpViewController: UIViewController {

    @IBOutlet private weak var scrollView: UIScrollView!
    
    @IBOutlet var inputViews: [TextInputView]!
    @IBOutlet private weak var emailTextView: TextInputView!
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var skipButton: UIButton!
    @IBOutlet private weak var applyButton: UIButton!
    @IBOutlet private weak var privacyLabel: UILabel!
    @IBOutlet private weak var registrationLabel: UILabel!
    @IBOutlet private weak var accountLabel: UILabel!
    @IBOutlet private weak var loginButton: UIButton!
    
    private var tapGesture: UITapGestureRecognizer!
    private var privacyGesture: UITapGestureRecognizer!
    private var scrollViewInsets: UIEdgeInsets!

    var model: SignUpInput!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupLocalization()
    }
    
    // MARK: - Actions
    @IBAction func apply(_ sender: UIButton) {
            if self.inputViews.allSatisfy({$0.validate()}) {
                sender.isUserInteractionEnabled = false

                let emailString: String? = emailTextView.validate() ? emailTextView.text : ""
                model.signUp(name: self.inputViews[0].text, phone: self.inputViews[1].text, email: emailString)
        }
}
    
    @IBAction func skipSignUp(_ sender: UIButton) {
        skipRegistrationAlertViewController()
    }
    
    @IBAction func back(_ sender: UIButton) {
        model.close()
    }
    
    // MARK: - Setup
    private func setupUI() {
        
        inputViews[0].contentType = .name
        inputViews[1].contentType = .phone
        inputViews.forEach({
            $0.textFieldDelegate = self
        })

        emailTextView.contentType = .email
        emailTextView.textFieldDelegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardDidHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        scrollView.addGestureRecognizer(tapGesture)
        scrollViewInsets = scrollView.contentInset
        
        privacyGesture = UITapGestureRecognizer(target: self, action: #selector(openPrivacyPolicy))
        privacyLabel.addGestureRecognizer(privacyGesture)
        
        applyButton.layer.cornerRadius = applyButton.frame.height / 2
    }
    
    private func setupLocalization() {
        
        titleLabel.text = R.string.localize.signupTitle.localized()
        descriptionLabel.text = R.string.localize.signupDescription.localized()
        skipButton.setTitle(R.string.localize.signupSkip.localized(), for: .normal)
        registrationLabel.text = R.string.localize.signupRegistration.localized()
        accountLabel.text = R.string.localize.signupAccount.localized()
        loginButton.setTitle(R.string.localize.loginSignin.localized(), for: .normal)
        
        if let font: UIFont = R.font.openSansRegular(size: 14) {
            
            var attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: R.color.textDarkBlue() ??  UIColor.black]
            let attrText: NSMutableAttributedString = NSMutableAttributedString(string: R.string.localize.signupPrivacy.localized(), attributes: attributes)
            attributes[NSAttributedString.Key.foregroundColor] = UIColor.systemBlue
            let linkText: NSAttributedString = NSMutableAttributedString(string: R.string.localize.signupLink.localized(), attributes: attributes)
            attrText.append(linkText)
            privacyLabel.attributedText = attrText
        }
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
    
    @IBAction func onLoginButtonTouchUp(_ sender: UIButton) {
        model.close()
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
            inputViews.forEach({$0.endEditing(true)})
            emailTextView.endEditing(true)
            guard inputViews.allSatisfy({$0.validate()}) else {
                registrationLabel.textColor = R.color.applyBlueGray()
                return}
            registrationLabel.textColor = R.color.textDarkBlue()
    }
    
    @objc private func openPrivacyPolicy(sender: UIGestureRecognizer) {
        
        let size = privacyLabel.intrinsicContentSize
        let firstLineRect: CGRect = CGRect(x: size.width / 2, y: 0, width: size.width / 2, height: size.height / 2)
        let secondLineRect: CGRect = CGRect(x: 0, y: size.height / 2, width: size.width, height: size.height / 2)
        
        let location: CGPoint = sender.location(in: privacyLabel)
        
        if firstLineRect.contains(location) || secondLineRect.contains(location) {
            
            print("open privacy")
        }
    }
}

// MARK: - UITextFieldDelegate

extension SignUpViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.tag + 1 < inputViews.count {
            inputViews[textField.tag + 1].startEditing()
        } else {
            apply(applyButton)
        }
        
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - SignUpOutput

extension SignUpViewController: SignUpOutput {    
    
    func failedToSignUp(message: String) {
        showError(message: message)
    }
    
    func unblockApplyButton() {
        applyButton.isUserInteractionEnabled = true
    }
}
