//
//  SignInViewController.swift
//  Pharmacy
//
//  Created by Mikhail Timoscenko on 16.06.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

final class SignInViewController: UIViewController {

    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbDescription: UILabel!
    @IBOutlet weak var phoneInputView: TextInputView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var socialLabel: UILabel!
    
    private var tapGesture: UITapGestureRecognizer!
    private var scrollViewInsets: UIEdgeInsets!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLocalization()
        phoneInputView.contentType = .phone
        navigationController?.navigationBar.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardDidHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        scrollView.addGestureRecognizer(tapGesture)
        scrollViewInsets = scrollView.contentInset
    }
    
    func setupLocalization() {
        
        lbTitle.text = R.string.localize.loginTitle()
        lbDescription.text = R.string.localize.loginDescription()
        applyButton.setTitle(R.string.localize.loginApply(), for: .normal)
        registerButton.setTitle(R.string.localize.loginSignup(), for: .normal)
        accountLabel.text = R.string.localize.loginAccount()
        socialLabel.text = R.string.localize.loginSocial()
    }
    
    // MARK: - Actions
    
    @IBAction func apply(_ sender: UIButton) {
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
