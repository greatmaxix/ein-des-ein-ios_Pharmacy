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
    private var scrollViewInsets: UIEdgeInsets!
    var model: SignUpInput!
    
    private var areFieldsValid: Bool {
        return inputViews.allSatisfy({$0.validate()})
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupLocalization()
        navigationController?.navigationBar.isHidden = false
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
        
        applyButton.layer.cornerRadius = applyButton.frame.height / 2
        facebookButton.layer.cornerRadius = facebookButton.frame.height / 2
        googleButton.layer.cornerRadius = googleButton.frame.height / 2
        appleButton.layer.cornerRadius = appleButton.frame.height / 2
        
        facebookButton.dropShadow(scale: true, color: R.color.shadowBlue(), width: 0, height: 6, radius: 8, opacity: 0.1)
        googleButton.dropShadow(scale: true, color: R.color.shadowBlue(), width: 0, height: 6, radius: 8, opacity: 0.1)
        appleButton.dropShadow(scale: true, color: R.color.shadowBlue(), width: 0, height: 6, radius: 8, opacity: 0.1)
    }
    
    private func setupLocalization() {
        
        titleLabel.text = R.string.localize.signupTitle()
        descriptionLabel.text = R.string.localize.signupDescription()
        socialNetworksLabel.text = R.string.localize.signupSocial()
        skipButton.setTitle(R.string.localize.signupSkip(), for: .normal)
        registrationLabel.text = R.string.localize.signupRegistration()
        privacyLabel.text = R.string.localize.signupPrivacy() +
            R.string.localize.signupLink()
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
    
    func unblockApplyButton() {
        applyButton.isUserInteractionEnabled = true
    }
}
