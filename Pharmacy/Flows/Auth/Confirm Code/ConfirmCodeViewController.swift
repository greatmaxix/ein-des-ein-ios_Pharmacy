//
//  ConfirmCodeViewController.swift
//  Pharmacy
//
//  Created by CGI-Kite on 19.06.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

final class ConfirmCodeViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var confirmTextLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var resendCodeLabel: UILabel!
    @IBOutlet weak var resendButton: UIButton!
    @IBOutlet weak var confirmCodeView: ConfirmCodeView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        confirmCodeView.delegate = self
        setupLocalization()
    }
    
    func setupLocalization() {
        
        titleLabel.text = R.string.localize.confirmTitle()
        confirmTextLabel.text = R.string.localize.confirmDescription()
        resendCodeLabel.text = R.string.localize.confirmResendCode()
        let attrs: [NSAttributedString.Key: Any] = [.font: R.font.sourceSansProBold(size: 12) ?? UIFont.systemFont(ofSize: 12, weight: .bold),
                                                    .underlineStyle: 1, .foregroundColor: R.color.textDarkGray()!]
        
        let attrText: NSAttributedString = NSAttributedString(string: R.string.localize.confirmResendAgain(), attributes: attrs)
        resendButton.setAttributedTitle(attrText, for: .normal)
    }

    @IBAction func resendCode(_ sender: UIButton) {
    }
}

extension ConfirmCodeViewController: ConfirmCodeDelegate {
    
    func lastDigitWasInputed(code: String) {
        //
    }
}
