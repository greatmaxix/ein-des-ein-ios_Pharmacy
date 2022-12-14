//
//  CheckoutViewController.swift
//  Pharmacy
//
//  Created by CGI-Kite on 31.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

protocol CheckoutViewControllerInput: CheckoutInput {}
protocol CheckoutViewControllerOutput: CheckoutOutput { }

protocol CheckoutOutput: class {
    func setupCustomer(name: String, phone: String, email: String)
    func setupMedicines()
    func setupFarmacy()
    func setupDeliveryAddress()
    func setupOrderInfo()
}

final class CheckoutViewController: UIViewController, NavigationBarStyled {
    
    @IBOutlet private weak var contactInfoLabel: UILabel!
    @IBOutlet private weak var contactInfoButton: UIButton!
    
    @IBOutlet private weak var customerInfoView: UIView!
    @IBOutlet private weak var editCustomerView: UIView!
        
    @IBOutlet private weak var nameFilledLabel: UILabel!
    @IBOutlet private weak var phoneFilledLabel: UILabel!
    @IBOutlet private weak var emailFilledLabel: UILabel!
    
    @IBOutlet private weak var nameInputView: TextInputView!
    @IBOutlet private weak var phoneInputView: TextInputView!
    @IBOutlet private weak var emailInputView: TextInputView!
    
    @IBOutlet private weak var deliveryTitleLabel: UILabel!
    @IBOutlet private weak var customerAddressLabel: UILabel!
    
    @IBOutlet private weak var deliveryButton: UIButton!
    @IBOutlet private weak var pickupButton: UIButton!
    @IBOutlet private weak var deliveryLabel: UILabel!
    @IBOutlet private weak var pickupLabel: UILabel!
    
    @IBOutlet private weak var deliveryAddresHeader: UIView!
    @IBOutlet private weak var deliveryAddressLabel: UILabel!
    @IBOutlet private weak var showDeliveryButton: UIButton!
    
    @IBOutlet private weak var cityInputView: TextInputView!
    @IBOutlet private weak var streetInputView: TextInputView!
    @IBOutlet private weak var houseInputView: TextInputView!
    @IBOutlet private weak var flatNumberInputView: TextInputView!
    
    @IBOutlet private weak var descriptionTextView: UITextView!
    @IBOutlet private weak var descriptionPlaceholderLabel: UILabel!
    @IBOutlet private weak var descriptionBackgroundView: UIView!
    
    @IBOutlet private weak var cityAddress: UILabel!
    @IBOutlet private weak var houseAddress: UILabel!
    
    @IBOutlet private weak var farmacyNameLabel: UILabel!
    @IBOutlet private weak var farmacyAddressLabel: UILabel!
    @IBOutlet private weak var farmacyPhoneLabel: UILabel!
    @IBOutlet private weak var farmacyWorkTimeLabel: UILabel!
    @IBOutlet private weak var farmacyMapButton: UIButton!
    @IBOutlet private weak var customerAddresEditView: UIView!
    @IBOutlet private weak var customerAddressView: UIView!
    
    @IBOutlet private weak var paymentMethodLabel: UILabel!
    @IBOutlet private weak var paymentStackView: UIStackView!
    @IBOutlet weak var paymentHeightConstr: NSLayoutConstraint!
    
    @IBOutlet private weak var orderLabel: UILabel!
    @IBOutlet private weak var orderButton: UIButton!
    @IBOutlet private weak var medicineStackView: UIStackView!
    @IBOutlet private weak var medicineHeightConstr: NSLayoutConstraint!
    
    @IBOutlet private weak var sumTitleLabel: UILabel!
    @IBOutlet private weak var deliverySumTitleLabel: UILabel!
    @IBOutlet private weak var sumLabel: UILabel!
    @IBOutlet private weak var deliverySumLabel: UILabel!
    
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var priceTitleLabel: UILabel!
    @IBOutlet private weak var applyButton: UIButton!
    
    var model: CheckoutInput!
    var style: NavigationBarStyle {
        .normalWithoutSearch
    }

    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupLocalization()
        setupOrder()
        descriptionTextView.delegate = self
        
        model.loadOrder()
    }

    func setupUI() {
        
        title = R.string.localize.checkoutTitle.localized()
        
        deliveryButton.layer.borderColor = R.color.welcomeBlue()?.cgColor
        pickupButton.layer.borderColor = R.color.textDarkBlue()?.cgColor
        descriptionBackgroundView.layer.borderColor = R.color.validationGray()?.cgColor
        
        cityInputView.contentType = .other
        streetInputView.contentType = .other
        houseInputView.contentType = .other
        flatNumberInputView.contentType = .other
        
        nameInputView.contentType = .name
        phoneInputView.contentType = .phone
        emailInputView.contentType = .email
    }
    
    func setupLocalization() {
        
        contactInfoLabel.text = R.string.localize.checkoutContactData.localized()
        contactInfoButton.setTitle(R.string.localize.checkoutChange.localized(), for: .normal)
        
        nameInputView.placeholder = R.string.localize.checkoutName.localized()
        phoneInputView.placeholder = R.string.localize.checkoutPhone.localized()
        emailInputView.placeholder = R.string.localize.checkoutEmail.localized()
        
        deliveryTitleLabel.text = R.string.localize.checkoutDeliveryType.localized()
        deliveryLabel.text = R.string.localize.checkoutDelivery.localized()
        pickupLabel.text = R.string.localize.checkoutPickup.localized()
        deliveryAddressLabel.text = R.string.localize.checkoutFarmacyAddress.localized()
        
        showDeliveryButton.setTitle(R.string.localize.checkoutChange.localized(), for: .normal)
        cityInputView.placeholder = R.string.localize.checkoutCity.localized()
        streetInputView.placeholder = R.string.localize.checkoutStreet.localized()
        houseInputView.placeholder = R.string.localize.checkoutHouseNumber.localized()
        flatNumberInputView.placeholder = R.string.localize.checkoutFlatNumber.localized()
        
        descriptionPlaceholderLabel.text = R.string.localize.checkoutDescription.localized()
        paymentMethodLabel.text = R.string.localize.checkoutPaymentType.localized()
        customerAddressLabel.text = R.string.localize.checkoutDeliveryAddress.localized()
        orderLabel.text = R.string.localize.checkoutOrderConsistence.localized()
        orderButton.setTitle(R.string.localize.checkoutChange.localized(), for: .normal)
        
        sumTitleLabel.text = R.string.localize.checkoutWhorePrice.localized()
        deliverySumTitleLabel.text = R.string.localize.checkoutDelivery.localized()
        priceTitleLabel.text = R.string.localize.checkoutFinalPrice.localized()
        applyButton.setTitle(R.string.localize.checkoutApplyPurchase.localized(), for: .normal)
    }
    
    private func setupOrder() {
        
        var paymentViewHeight: CGFloat = 0
        for _ in 0..<3 {
            if let paymentView: PaymentMethodView = R.nib.paymentMethodView(owner: nil) {
                paymentStackView.addArrangedSubview(paymentView)
                paymentViewHeight = paymentView.frame.height
            }
        }
        paymentHeightConstr.constant = 3 * paymentViewHeight
        
        var medicineViewHeight: CGFloat = 0
        for _ in 0..<3 {
            if let medicineView: MedicineView = R.nib.medicineView(owner: nil) {
                medicineStackView.addArrangedSubview(medicineView)
                medicineViewHeight = medicineView.frame.height
            }
        }
        medicineHeightConstr.constant = 3 * medicineViewHeight + 2 * medicineStackView.spacing
    }
    
    // MARK: - Outlets
    
    @IBAction private func selectDelivery(_ sender: UIButton) {
         
        let selectedDelivery: Bool = sender == deliveryButton
        let deselectedButton: UIButton = selectedDelivery ? pickupButton : deliveryButton
        
        let selectedLabel: UILabel = selectedDelivery ? deliveryLabel : pickupLabel
        let deselectedLabel: UILabel = !selectedDelivery ? deliveryLabel : pickupLabel
        
        setDeliveryStyle(button: sender, label: selectedLabel, isSelected: true)
        setDeliveryStyle(button: deselectedButton, label: deselectedLabel, isSelected: false)

        customerAddresEditView.isHidden = !selectedDelivery
        customerAddressView.isHidden = true
        deliveryAddresHeader.isHidden = !selectedDelivery
    }
    
    @IBAction func editCustomerInfo(_ sender: UIButton) {
        sender.isHidden = true
        customerInfoView.isHidden = true
        editCustomerView.isHidden = false
    }
    @IBAction func editFarmacyAddress(_ sender: UIButton) {
        sender.isHidden = true
    }
    
    @IBAction func editCustomerAddress(_ sender: UIButton) {
        sender.isHidden = true
        customerAddressView.isHidden = true
        customerAddresEditView.isHidden = false
    }
    @IBAction func editOrder() {
    }

    @IBAction func applyOrder() {
    }
    
    func setDeliveryStyle(button: UIButton, label: UILabel, isSelected: Bool) {
        
        button.layer.borderColor = isSelected ?  R.color.welcomeBlue()?.cgColor : R.color.textDarkBlue()?.cgColor
        button.tintColor = isSelected ?  R.color.welcomeBlue() : R.color.textDarkBlue()
        label.textColor = isSelected ?  R.color.welcomeBlue() : R.color.textDarkBlue()
        label.font = isSelected ? R.font.openSansSemiBold(size: 14) : R.font.openSansRegular(size: 14)
    }
    
}

extension CheckoutViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        descriptionPlaceholderLabel.isHidden = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text == nil || textView.text == "" {
            descriptionPlaceholderLabel.isHidden = false
        }
    }
}

extension CheckoutViewController: CheckoutViewControllerOutput {
    
    func setupCustomer(name: String, phone: String, email: String) {
        nameFilledLabel.text = name
        phoneFilledLabel.text = "📱 " + phone
        emailFilledLabel.text = "📪 " + email
        
        nameInputView.text = name
        emailInputView.text = email
        phoneInputView.text = phone
    }
    
    func setupOrderInfo() {
        //
    }
    
    func setupMedicines() {
        //
    }
    
    func setupFarmacy() {
        //
    }
    
    func setupDeliveryAddress() {
        //
    }
}
