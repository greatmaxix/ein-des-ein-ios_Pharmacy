//
//  SignUpViewController.swift
//  Pharmacy
//
//  Created by Mikhail Timoscenko on 16.06.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var tiName: TextInputView!
    @IBOutlet weak var tiPhone: TextInputView!
    @IBOutlet weak var tiEmail: TextInputView!
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbDescription: UILabel!
    @IBOutlet weak var lbSocialNetworks: UILabel!
    @IBOutlet weak var btSkip: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupLocalization()
    }
    
    @IBAction func btApplyDidClicked(_ sender: UIButton) {
    }
    
    private func setupUI() {
        
        navigationController?.isNavigationBarHidden = true
        tiName.contentType = .name
        tiPhone.contentType = .phone
        tiEmail.contentType = .email
    }
    
    private func setupLocalization() {
        
        lbTitle.text = R.string.localize.loginTitle()
        lbDescription.text = R.string.localize.loginDescription()
        lbSocialNetworks.text = R.string.localize.loginSocial()
        btSkip.setTitle(R.string.localize.loginSkip(), for: .normal)
    }
            
}
