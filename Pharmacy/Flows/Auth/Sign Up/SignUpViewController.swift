//
//  SignUpViewController.swift
//  Pharmacy
//
//  Created by Mikhail Timoscenko on 16.06.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

final class SignUpViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet var inputViews: [TextInputView]!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var socialNetworksLabel: UILabel!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var privacyLabel: UILabel!
    @IBOutlet weak var registrationLabel: UILabel!
    
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var appleButton: UIButton!
    
    private var tapGesture: UITapGestureRecognizer!
    private var privacyGesture: UITapGestureRecognizer!
    private var scrollViewInsets: UIEdgeInsets!
    var model: SignUpInput!
    
    private var areFieldsValid: Bool {
        return inputViews.allSatisfy({$0.validate()})
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupLocalization()
        navigationController?.navigationBar.isHidden = true
    }
        
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    // MARK: - Actions
    
    @IBAction func apply(_ sender: UIButton) {
        
        if areFieldsValid {
            
            sender.isUserInteractionEnabled = false
            model.signUp(name: inputViews[0].text, phone: inputViews[1].text, email: inputViews[2].text)
        }
    }
    
    @IBAction func skipSignUp(_ sender: UIButton) {
    }
    
    @IBAction func back(_ sender: UIButton) {
        model.close()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        
        inputViews[0].contentType = .name
        inputViews[1].contentType = .phone
        inputViews[2].contentType = .email
        inputViews.forEach({
            $0.textFieldDelegate = self
            $0.returnKeyType = .next
        })

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardDidHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        scrollView.addGestureRecognizer(tapGesture)
        scrollViewInsets = scrollView.contentInset
        
        privacyGesture = UITapGestureRecognizer(target: self, action: #selector(openPrivacyPolicy))
        privacyLabel.addGestureRecognizer(privacyGesture)
        
        applyButton.layer.cornerRadius = applyButton.frame.height / 2
        facebookButton.layer.cornerRadius = facebookButton.frame.height / 2
        googleButton.layer.cornerRadius = googleButton.frame.height / 2
        appleButton.layer.cornerRadius = appleButton.frame.height / 2
        
        facebookButton.dropBlueShadow()
        googleButton.dropBlueShadow()
        appleButton.dropBlueShadow()
    }
    
    private func setupLocalization() {
        
        titleLabel.text = R.string.localize.signupTitle()
        descriptionLabel.text = R.string.localize.signupDescription()
        socialNetworksLabel.text = R.string.localize.signupSocial()
        skipButton.setTitle(R.string.localize.signupSkip(), for: .normal)
        registrationLabel.text = R.string.localize.signupRegistration()
        
        if let font: UIFont = R.font.openSansRegular(size: 14) {
            
            var attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: R.color.textDarkBlue() ??  UIColor.black]
            let attrText: NSMutableAttributedString = NSMutableAttributedString(string: R.string.localize.signupPrivacy(), attributes: attributes)
            attributes[NSAttributedString.Key.foregroundColor] = UIColor.systemBlue
            let linkText: NSAttributedString = NSMutableAttributedString(string: R.string.localize.signupLink(), attributes: attributes)
            attrText.append(linkText)
            privacyLabel.attributedText = attrText
        }
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
