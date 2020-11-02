//
//  ChooseDeliveryAdressViewController.swift
//  Pharmacy
//
//  Created by Sergey berdnik on 02.11.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD

class ChooseDeliveryAdressViewController: UIViewController {
    
    var model: ChooseDeliveryAdressInput!
    private var activityIndicator: MBProgressHUD!
    
    @IBOutlet private weak var scrollView: UIScrollView!
    private var scrollViewInsets: UIEdgeInsets!
    
    @IBOutlet private weak var cityTextView: TextInputView!
    @IBOutlet private weak var streetTextView: TextInputView!
    @IBOutlet private weak var houseTextView: TextInputView!
    @IBOutlet private weak var pavilionTextView: TextInputView!
    @IBOutlet private weak var flatTextView: TextInputView!
    
    @IBOutlet private weak var noteTextView: TextInputView!
    
    @IBOutlet private weak var applyButton: UIButton!
    
    private lazy var validationView: [TextInputView]  = {
        [cityTextView, streetTextView, houseTextView]
    }()
    
    private enum GUI {
        static let fontSize: Int = 14
        static let noteTextViewHeight: Int = 120
        
    }
    
        override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator = setupActivityIndicator()
        setupNavBar()
        setupValidationViews()
        setupNoteView()
        setupApplyButton()
        blockApplyButton()
        setupScrollView()
        setupKeyboard()
        setupScrollView()
    }
    
    private func setupNavBar() {
      if let bar = navigationController?.navigationBar as? SimpleNavigationBar {
        bar.style = .search
        bar.isLeftItemHidden = false
        bar.isRightItemHidden = true
        bar.title = R.string.localize.deliveryTitle()
        bar.leftItemTitle = R.string.localize.profileProfile()
        bar.barDelegate = self
      }
    }
    
    private func setupScrollView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        scrollView.addGestureRecognizer(tapGesture)
        scrollViewInsets = scrollView.contentInset
    }
    
    private func setupKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardDidHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    private func setupValidationViews() {
        cityTextView.contentType = .city
        streetTextView.contentType = .street
        
        houseTextView.contentType = .house
        houseTextView.setupFontSize(fontSize: GUI.fontSize)
        houseTextView.setupTextFieldSpaceing(leading: 10, trailing: 0, top: 3, bottom: 3)
        houseTextView.setupKeyboardType(type: .numberPad)
        
        validationView.forEach({[unowned self] in $0.textFieldDelegate = self})
        
        pavilionTextView.placeholder = R.string.localize.deliveryPavilion()
        pavilionTextView.setupFontSize(fontSize: GUI.fontSize)
        pavilionTextView.statusButtonDisable()
        pavilionTextView.setupTextFieldSpaceing(leading: 10, trailing: 0, top: 3, bottom: 3)
        pavilionTextView.setupKeyboardType(type: .numberPad)
        
        flatTextView.placeholder = R.string.localize.deliveryFlat()
        flatTextView.setupFontSize(fontSize: GUI.fontSize)
        flatTextView.statusButtonDisable()
        flatTextView.setupTextFieldSpaceing(leading: 10, trailing: 0, top: 3, bottom: 3)
        flatTextView.setupKeyboardType(type: .numberPad)
    }
    
    private func setupNoteView() {
        noteTextView.placeholder = R.string.localize.deliveryNote()
        noteTextView.setupFontSize(fontSize: GUI.fontSize)
        noteTextView.setupHeightTextView(height: GUI.noteTextViewHeight)
        noteTextView.statusButtonDisable()
    }
    
    private func setupApplyButton() {
        applyButton.setTitle(R.string.localize.deliveryApplyButton(), for: .normal)
        applyButton.layer.cornerRadius = applyButton.frame.height/2
    }
    
    func unblockApplyButton() {
        applyButton.isUserInteractionEnabled = true
        applyButton.backgroundColor = R.color.validationBlue()
    }
    
    func blockApplyButton() {
        applyButton.isUserInteractionEnabled = false
        applyButton.backgroundColor = R.color.applyBlueGray()
    }
    
    // MARK: - Actions
    @IBAction func apply(_ sender: UIButton) {
            if self.validationView.allSatisfy({$0.validate()}) {
                sender.isUserInteractionEnabled = false
    // TODO :- нужно сделать реалзицию приведения полей в соответсвии с сервером
                model.saveDeliveryAddress(city: cityTextView.text!, street: streetTextView.text!,
                                          house: houseTextView.text!, pavilion: pavilionTextView.text,
                                          flat: flatTextView.text, note: noteTextView.text)
        }
    }
    
    // MARK: - Keyboard
    
    @objc private func hideKeyboard() {
            scrollView.contentInset = scrollViewInsets
            guard validationView.allSatisfy({$0.validate()}) else {
                blockApplyButton()
                return
            }
        unblockApplyButton()
    }

    @objc private func keyboardWillAppear(notification: NSNotification) {
        if let rect: CGRect = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            
            scrollView.contentInset = UIEdgeInsets(top: scrollViewInsets.top, left: scrollViewInsets.left, bottom: scrollViewInsets.bottom + rect.height, right: scrollViewInsets.right)
        }
    }
    
    @objc private func keyboardWillDisappear() {
        scrollView.contentInset = scrollViewInsets
    }
}

extension ChooseDeliveryAdressViewController: ChooseDeliveryAdressOutput {}

extension ChooseDeliveryAdressViewController: SimpleNavigationBarDelegate, UITextFieldDelegate {
    
    func leftBarItemAction() {
        model.close()
    }
    
    func rightBarItemAction() {}
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag + 1 < validationView.count {
            validationView[textField.tag + 1].startEditing()
        } else {
            apply(applyButton)
        }
        
        textField.resignFirstResponder()
        return true
    }
}
