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
        
    }
    
    func setupLocalization() {
        
    }
    
}
