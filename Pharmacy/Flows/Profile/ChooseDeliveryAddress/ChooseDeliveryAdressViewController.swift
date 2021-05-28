//
//  ChooseDeliveryAdressViewController.swift
//  Pharmacy
//
//  Created by Sergey berdnik on 02.11.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import UIKit

class ChooseDeliveryAdressViewController: UIViewController {
    
    var model: ChooseDeliveryAdressInput!
    
    @IBOutlet private weak var scrollView: UIScrollView!
    
    private var scrollViewInsets: UIEdgeInsets!
    
    @IBOutlet private weak var cityTextView: TextInputView!
    @IBOutlet private weak var streetTextView: TextInputView!
    @IBOutlet private weak var houseTextView: TextInputView!
    @IBOutlet private weak var pavilionTextView: TextInputView!
    @IBOutlet private weak var flatTextView: TextInputView!
    
    @IBOutlet private weak var noteTextView: UITextView!
    
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
        setupNavBar()
        setupTargets()
        setupValidationViews()
        setupNoteView()
        setupApplyButton()
        blockApplyButton()
        setupScrollView()
        setupKeyboard()
        setupScrollView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        PulseLoaderService.showAdded(to: view)
    }
    
    private func setupNavBar() {
        if let bar = navigationController?.navigationBar as? SimpleNavigationBar {
            bar.style = .search
            bar.isLeftItemHidden = false
            bar.isRightItemHidden = true
            bar.title = R.string.localize.deliveryTitle.localized()
            bar.leftItemTitle = R.string.localize.profileProfile.localized()
            bar.barDelegate = self
        }
    }
    
    private func setupTargets() {
        validationView.forEach {
            $0.addTextFieldTarget(self, action: #selector(manageSaveButton), for: .editingChanged)
         }
    }
    
    @objc private func manageSaveButton() {
        guard validationView.allSatisfy({$0.validate()}) else {
            blockApplyButton()
            return
        }
        unblockApplyButton()
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
        
        pavilionTextView.placeholder = R.string.localize.deliveryPavilion.localized()
        pavilionTextView.setupFontSize(fontSize: GUI.fontSize)
        pavilionTextView.statusButtonDisable()
        pavilionTextView.setupTextFieldSpaceing(leading: 10, trailing: 0, top: 3, bottom: 3)
        pavilionTextView.setupKeyboardType(type: .numberPad)
        
        flatTextView.placeholder = R.string.localize.deliveryFlat.localized()
        flatTextView.setupFontSize(fontSize: GUI.fontSize)
        flatTextView.statusButtonDisable()
        flatTextView.setupTextFieldSpaceing(leading: 10, trailing: 0, top: 3, bottom: 3)
        flatTextView.setupKeyboardType(type: .numberPad)
    }
    
    private func setupNoteView() {
        noteTextView.text = R.string.localize.deliveryNote.localized()
        noteTextView.textColor = R.color.applyBlueGray()?.withAlphaComponent(0.7)
        noteTextView.font = R.font.openSansRegular(size: 14)
        
        noteTextView.backgroundColor = R.color.backgroundGray()
        
        noteTextView.layer.cornerRadius = noteTextView.frame.height / 2
        noteTextView.layer.borderWidth = 1
        noteTextView.layer.borderColor = R.color.validationGray()?.cgColor
        noteTextView.layer.sublayerTransform = CATransform3DMakeTranslation(30, 0, 0)
        noteTextView.delegate = self
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

extension ChooseDeliveryAdressViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.text == R.string.localize.deliveryNote.localized() {
            textView.text = ""
            textView.textColor = .black
        }
        textView.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text == "" {
            textView.text = R.string.localize.deliveryNote.localized()
            textView.textColor = R.color.applyBlueGray()?.withAlphaComponent(0.7)
        }
        textView.resignFirstResponder()
    }
}
