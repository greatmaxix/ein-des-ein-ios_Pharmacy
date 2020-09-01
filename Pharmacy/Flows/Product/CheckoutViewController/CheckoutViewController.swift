//
//  CheckoutViewController.swift
//  Pharmacy
//
//  Created by CGI-Kite on 31.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

final class CheckoutViewController: UIViewController {
    
    @IBOutlet weak var contactInfoLabel: UILabel!
    @IBOutlet weak var contactInfoButton: UIButton!
    
    @IBOutlet private weak var nameFilledLabel: UILabel!
    @IBOutlet private weak var phoneFilledLabel: UILabel!
    @IBOutlet private weak var emailFilledLabel: UILabel!
    
    @IBOutlet private weak var nameInputView: TextInputView!
    @IBOutlet private weak var phoneInputView: TextInputView!
    @IBOutlet private weak var emailInputView: TextInputView!
    
    @IBOutlet private weak var deliveryTitleLabel: UILabel!
    
    @IBOutlet private weak var deliveryButton: UIButton!
    @IBOutlet private weak var pickupButton: UIButton!
    @IBOutlet private weak var deliveryImageView: UIImageView!
    @IBOutlet private weak var pickupImageView: UIImageView!
    @IBOutlet private weak var deliveryLabel: UILabel!
    @IBOutlet private weak var pickupLabel: UILabel!
    
    @IBOutlet weak var deliveryAddressLabel: UILabel!
    @IBOutlet weak var showDeliveryButton: UIButton!
    
    @IBOutlet private weak var cityInputView: TextInputView!
    @IBOutlet private weak var streetInputView: TextInputView!
    @IBOutlet private weak var houseInputView: TextInputView!
    @IBOutlet private weak var flatNumberInputView: TextInputView!
    @IBOutlet private weak var descriptionTextView: UITextView!
    
    @IBOutlet private weak var cityAddress: UILabel!
    @IBOutlet private weak var houseAddress: UILabel!
    
    @IBOutlet private weak var cellBackgroundView: UIView!
    @IBOutlet private weak var farmacyNameLabel: UILabel!
    @IBOutlet private weak var farmacyAddressLabel: UILabel!
    @IBOutlet private weak var farmacyPhoneLabel: UILabel!
    @IBOutlet private weak var farmacyWorkTimeLabel: UILabel!
    @IBOutlet private weak var farmacyMapButton: UIButton!
    
    @IBOutlet private weak var paymentMethodLabel: UILabel!
    @IBOutlet private weak var paymentMethodButton: UIButton!
    @IBOutlet private weak var paymentStackView: UIStackView!

    @IBOutlet private weak var orderLabel: UILabel!
    @IBOutlet private weak var orderButton: UIButton!
    @IBOutlet weak var medicineStackView: UIStackView!
    
    @IBOutlet private weak var sumTitleLabel: UILabel!
    @IBOutlet private weak var discountTitleLabel: UILabel!
    @IBOutlet private weak var deliverySumTitleLabel: UILabel!
    @IBOutlet private weak var sumLabel: UILabel!
    @IBOutlet private weak var discountLabel: UILabel!
    @IBOutlet private weak var deliverySumLabel: UILabel!
    
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var priceTitleLabel: UILabel!
    @IBOutlet private weak var promocodeButton: UIButton!
    @IBOutlet private weak var applyButton: UIButton!
    
    var model: CheckoutInput!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupLocalization()
    }

    func setupUI() {
        deliveryButton.layer.borderWidth = 2
        deliveryButton.layer.borderColor = R.color.welcomeBlue()?.cgColor
        deliveryButton.layer.cornerRadius = 8
         
        pickupButton.layer.borderWidth = 2
        pickupButton.layer.borderColor = R.color.textDarkBlue()?.cgColor
        pickupButton.layer.cornerRadius = 8
        
        promocodeButton.layer.cornerRadius = promocodeButton.bounds.height / 2
        applyButton.layer.cornerRadius = applyButton.bounds.height / 2
        
        cityInputView.contentType = .other
        streetInputView.contentType = .other
        houseInputView.contentType = .other
        flatNumberInputView.contentType = .other
    }
    
    func setupLocalization() {
        
        contactInfoLabel.text = R.string.localize.checkoutContactData()
        contactInfoButton.setTitle(R.string.localize.checkoutChange(), for: .normal)
        
        nameInputView.placeholder = R.string.localize.checkoutName()
        phoneInputView.placeholder = R.string.localize.checkoutPhone()
        emailInputView.placeholder = R.string.localize.checkoutEmail()
        
        cityInputView.placeholder = R.string.localize.checkoutCity()
        streetInputView.placeholder = R.string.localize.checkoutStreet()
        houseInputView.placeholder = R.string.localize.checkoutHouseNumber()
        flatNumberInputView.placeholder = R.string.localize.checkoutFlatNumber()
        
        sumTitleLabel.text = R.string.localize.checkoutWhorePrice()
        discountTitleLabel.text = R.string.localize.checkoutDiscount()
        deliverySumTitleLabel.text = R.string.localize.checkoutDelivery()
        priceTitleLabel.text = R.string.localize.checkoutFinalPrice()
        promocodeButton.setTitle(R.string.localize.checkoutPromocode(), for: .normal)
        applyButton.setTitle(R.string.localize.checkoutApplyPurchase(), for: .normal)
    }
    
    @IBAction private func selectDelivery(_ sender: UIButton) {
         
         let selectedDelivery: Bool = sender == deliveryButton
         
         deliveryButton.layer.borderColor = selectedDelivery ?  R.color.welcomeBlue()?.cgColor : R.color.textDarkBlue()?.cgColor
         deliveryImageView.tintColor = selectedDelivery ?  R.color.welcomeBlue() : R.color.textDarkBlue()
         deliveryLabel.textColor = selectedDelivery ?  R.color.welcomeBlue() : R.color.textDarkBlue()
         deliveryLabel.font = selectedDelivery ? R.font.openSansSemiBold(size: 14) : R.font.openSansRegular(size: 14)
         
         pickupButton.layer.borderColor = !selectedDelivery ?  R.color.welcomeBlue()?.cgColor : R.color.textDarkBlue()?.cgColor
         pickupImageView.tintColor = !selectedDelivery ?  R.color.welcomeBlue() : R.color.textDarkBlue()
         pickupLabel.textColor = !selectedDelivery ?  R.color.welcomeBlue() : R.color.textDarkBlue()
         pickupLabel.font = !selectedDelivery ? R.font.openSansSemiBold(size: 14) : R.font.openSansRegular(size: 14)
     }
    
}
