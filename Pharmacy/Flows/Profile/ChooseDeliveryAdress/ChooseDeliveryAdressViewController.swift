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
    @IBOutlet private weak var cityTextView: TextInputView!
    @IBOutlet private weak var streetTextView: TextInputView!
    @IBOutlet private weak var houseTextView: TextInputView!
    @IBOutlet private weak var pavilionTextView: TextInputView!
    @IBOutlet private weak var flatTextView: TextInputView!
    
    @IBOutlet private weak var noteTextView: TextInputView!
    
    @IBOutlet private weak var applyButtonView: UIButton!
    
    private enum GUI {
    }
    
        override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator = setupActivityIndicator()
        setupNavBar()
        setupValidationViews()
        setupNoteView()
        setupApplyButton()
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
    
    private func setupValidationViews() {
        cityTextView.contentType = .city
        streetTextView.contentType = .street
        
        houseTextView.contentType = .house
        houseTextView.setupFontSize(fontSize: 14)
        houseTextView.setupTextFieldSpaceing(leading: 10, trailing: 0, top: 3, bottom: 3)
        
        pavilionTextView.placeholder = R.string.localize.deliveryPavilion()
        pavilionTextView.setupFontSize(fontSize: 14)
        pavilionTextView.setupTextFieldSpaceing(leading: 10, trailing: 0, top: 3, bottom: 3)
        pavilionTextView.setupKeyboardType(type: .numberPad)
        
        flatTextView.placeholder = R.string.localize.deliveryFlat()
        flatTextView.setupFontSize(fontSize: 14)
        flatTextView.setupTextFieldSpaceing(leading: 10, trailing: 0, top: 3, bottom: 3)
        flatTextView.setupKeyboardType(type: .numberPad)
    }
    private func setupNoteView() {
        noteTextView.placeholder = R.string.localize.deliveryNote()
        noteTextView.setupFontSize(fontSize: 14)
        noteTextView.setupHeightTextView(height: 120)
    }
    
    private func setupApplyButton() {
        applyButtonView.setTitle(R.string.localize.deliveryApplyButton(), for: .normal)
        applyButtonView.layer.cornerRadius = applyButtonView.frame.height/2
    }
}

extension ChooseDeliveryAdressViewController: ChooseDeliveryAdressOutput {
    
}

extension ChooseDeliveryAdressViewController: SimpleNavigationBarDelegate {
    func leftBarItemAction() {
        model.close()
    }
    
    func rightBarItemAction() {
        
    }
}
