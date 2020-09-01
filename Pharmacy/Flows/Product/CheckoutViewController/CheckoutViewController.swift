//
//  CheckoutViewController.swift
//  Pharmacy
//
//  Created by CGI-Kite on 31.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

final class CheckoutViewController: UIViewController {
    
    @IBOutlet private weak var contactInfoLabel: UILabel!
    @IBOutlet private weak var contactInfoButton: UIButton!
    
    @IBOutlet private weak var nameFilledLabel: UILabel!
    @IBOutlet private weak var phoneFilledLabel: UILabel!
    @IBOutlet private weak var emailFilledLabel: UILabel!
    @IBOutlet private weak var customerInfoView: UIView!
    
    @IBOutlet private weak var nameInputView: TextInputView!
    @IBOutlet private weak var phoneInputView: TextInputView!
    @IBOutlet private weak var emailInputView: TextInputView!
    
    @IBOutlet private weak var deliveryTitleLabel: UILabel!
    @IBOutlet private weak var customerAddressLabel: UILabel!
    
    @IBOutlet private weak var deliveryButton: UIButton!
    @IBOutlet private weak var pickupButton: UIButton!
    @IBOutlet private weak var deliveryLabel: UILabel!
    @IBOutlet private weak var pickupLabel: UILabel!
    
    @IBOutlet private weak var deliveryAddressLabel: UILabel!
    @IBOutlet private weak var showDeliveryButton: UIButton!
    @IBOutlet weak var filledAddresView: UIView!
    
    @IBOutlet private weak var cityInputView: TextInputView!
    @IBOutlet private weak var streetInputView: TextInputView!
    @IBOutlet private weak var houseInputView: TextInputView!
    @IBOutlet private weak var flatNumberInputView: TextInputView!
    
    @IBOutlet private weak var descriptionTextView: UITextView!
    @IBOutlet private weak var farmacyInfoView: UIView!
    @IBOutlet weak var descriptionBackgroundView: UIView!
    
    @IBOutlet private weak var cityAddress: UILabel!
    @IBOutlet private weak var houseAddress: UILabel!
    
    @IBOutlet private weak var farmacyNameLabel: UILabel!
    @IBOutlet private weak var farmacyAddressLabel: UILabel!
    @IBOutlet private weak var farmacyPhoneLabel: UILabel!
    @IBOutlet private weak var farmacyWorkTimeLabel: UILabel!
    @IBOutlet private weak var farmacyMapButton: UIButton!
    
    @IBOutlet private weak var paymentMethodLabel: UILabel!
    @IBOutlet private weak var paymentStackView: UIStackView!

    @IBOutlet private weak var orderLabel: UILabel!
    @IBOutlet private weak var orderButton: UIButton!
    @IBOutlet private weak var medicineStackView: UIStackView!
    
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
        
        title = R.string.localize.checkoutTitle()
        deliveryButton.layer.borderWidth = 2
        deliveryButton.layer.borderColor = R.color.welcomeBlue()?.cgColor
        deliveryButton.layer.cornerRadius = 8
        customerInfoView.layer.cornerRadius = 10
        farmacyInfoView.layer.cornerRadius = 10
        filledAddresView.layer.cornerRadius = 10
        
        pickupButton.layer.borderWidth = 2
        pickupButton.layer.borderColor = R.color.textDarkBlue()?.cgColor
        pickupButton.layer.cornerRadius = 8
        
        descriptionBackgroundView.layer.cornerRadius = descriptionBackgroundView.bounds.height / 4
        descriptionBackgroundView.layer.borderWidth = 1
        descriptionBackgroundView.layer.borderColor = R.color.validationGray()?.cgColor
        
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
        
        deliveryTitleLabel.text = R.string.localize.checkoutDeliveryType()
        deliveryLabel.text = R.string.localize.checkoutDelivery()
        pickupLabel.text = R.string.localize.checkoutPickup()
        deliveryAddressLabel.text = R.string.localize.checkoutFarmacyAddress()
        showDeliveryButton.setTitle(R.string.localize.checkoutChange(), for: .normal)
        cityInputView.placeholder = R.string.localize.checkoutCity()
        streetInputView.placeholder = R.string.localize.checkoutStreet()
        houseInputView.placeholder = R.string.localize.checkoutHouseNumber()
        flatNumberInputView.placeholder = R.string.localize.checkoutFlatNumber()
        paymentMethodLabel.text = R.string.localize.checkoutPaymentType()
        customerAddressLabel.text = R.string.localize.checkoutDeliveryAddress()
        orderLabel.text = R.string.localize.checkoutOrderConsistence()
        orderButton.setTitle(R.string.localize.checkoutChange(), for: .normal)
        
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
         deliveryButton.tintColor = selectedDelivery ?  R.color.welcomeBlue() : R.color.textDarkBlue()
         deliveryLabel.textColor = selectedDelivery ?  R.color.welcomeBlue() : R.color.textDarkBlue()
         deliveryLabel.font = selectedDelivery ? R.font.openSansSemiBold(size: 14) : R.font.openSansRegular(size: 14)
         
         pickupButton.layer.borderColor = !selectedDelivery ?  R.color.welcomeBlue()?.cgColor : R.color.textDarkBlue()?.cgColor
         pickupButton.tintColor = !selectedDelivery ?  R.color.welcomeBlue() : R.color.textDarkBlue()
         pickupLabel.textColor = !selectedDelivery ?  R.color.welcomeBlue() : R.color.textDarkBlue()
         pickupLabel.font = !selectedDelivery ? R.font.openSansSemiBold(size: 14) : R.font.openSansRegular(size: 14)
     }
    
}
